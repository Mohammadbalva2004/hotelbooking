import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hotelbooking/features/screen/auth/signin/signin_screen.dart';
import 'package:hotelbooking/features/screen/home/home_screen.dart';
import 'package:hotelbooking/features/widgets/commonbutton/common_buttom.dart';
import 'package:hotelbooking/features/widgets/commontextfromfild/Common_Text_FormField.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(
    const MaterialApp(debugShowCheckedModeBanner: false, home: SignupScreen()),
  );
}

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? _selectedGender;

  bool _obscureText = true;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var email = "";
  var password = "";

  Future<bool> registration() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await FirebaseAuth.instance.currentUser?.sendEmailVerification();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            "Registered Successfully. Please Login..",
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
      );

      return true; // ✅ success
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text(
              "Password must be at least 6 characters long ",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        );
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text(
              "Account already exists",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              "Registration failed: ${e.message}",
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      }
      return false; // ❌ failed
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Widget genderSelection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Gender",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          RadioListTile<String>(
            title: const Text('Male'),
            value: 'Male',
            groupValue: _selectedGender,
            onChanged: (value) {
              setState(() {
                _selectedGender = value;
              });
            },
            dense: true,
            contentPadding: EdgeInsets.zero,
            visualDensity: const VisualDensity(
              horizontal: VisualDensity.minimumDensity,
              vertical: VisualDensity.minimumDensity,
            ),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          RadioListTile<String>(
            title: const Text('Female'),
            value: 'Female',
            groupValue: _selectedGender,
            onChanged: (value) {
              setState(() {
                _selectedGender = value;
              });
            },
            dense: true,
            contentPadding: EdgeInsets.zero,
            visualDensity: const VisualDensity(
              horizontal: VisualDensity.minimumDensity,
              vertical: VisualDensity.minimumDensity,
            ),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Logo
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 200, top: 50),
              child: Image.asset("assets/images/splash.png"),
            ),
            // Title
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 180, top: 30),
              child: Text(
                "Register Now!",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            // Subtitle
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 140, top: 10),
              child: Text(
                "Enter your information below",
                style: TextStyle(fontSize: 15, color: Colors.grey),
              ),
            ),
            SizedBox(height: 20),

            Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CommonTextFormField(
                      controller: nameController,
                      labelText: "Name",
                      hintText: "Enter Name",
                      prefixIcon: Icon(Icons.person),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Name is required';
                        } else if (value.length < 3) {
                          return 'Name must be at least 3 characters';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CommonTextFormField(
                      controller: emailController,
                      labelText: "Email Address",
                      hintText: "Enter Email",
                      prefixIcon: Icon(Icons.email),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Email is required';
                        } else if (!RegExp(
                          r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$',
                        ).hasMatch(value)) {
                          return 'Enter a valid email';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CommonTextFormField(
                      controller: passwordController,
                      labelText: "Password",
                      hintText: "Enter Password",
                      prefixIcon: Icon(Icons.lock),
                      obscureText: _obscureText,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                      // validator: (value) {
                      //   if (value == null || value.isEmpty) {
                      //     return 'Password is required';
                      //   } else if (value.length < 6) {
                      //     return 'Password must be at least 6 characters long';
                      //   }
                      //   return null;
                      // },
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CommonTextFormField(
                      controller: phoneController,
                      labelText: "Mobile Number",
                      hintText: "Enter Mobile Number",
                      prefixIcon: Icon(Icons.phone),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Phone number is required';
                        } else if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                          return 'Enter a valid 10-digit number';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CommonTextFormField(
                      controller: dateController,
                      labelText: "Date Of Birth",
                      hintText: "Enter Date of Birth",
                      prefixIcon: Icon(Icons.calendar_today),
                      readOnly: true,
                      onTap: () => _selectDate(context),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Date of birth is required';
                        }
                        return null;
                      },
                    ),
                  ),
                  // add more fields or gender selection here if needed
                ],
              ),
            ),

            genderSelection(),
            SizedBox(height: 20),

            CustomButton(
              text: "Register",
              width: double.infinity,
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    email = emailController.text;
                    password = passwordController.text;
                  });

                  bool success = await registration(); // ⏳ Wait for result

                  if (success) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SigninScreen()),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please fix the errors in the form'),
                    ),
                  );
                }
              },
            ),

            SizedBox(height: 30),
            // Login Prompt
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already a member? ",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SigninScreen()),
                    );
                  },
                  child: Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 28, 135, 223),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
