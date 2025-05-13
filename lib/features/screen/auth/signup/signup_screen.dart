import 'package:flutter/material.dart';
import 'package:hotelbooking/features/screen/auth/signin/signin_screen.dart';
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

  String? _selectedGender;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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

  Widget customTextFormField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    IconData? icon,
    bool readOnly = false,
    VoidCallback? onTap,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        onTap: onTap,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          //floatingLabelBehavior: FloatingLabelBehavior.always,
          filled: true,
          fillColor: Colors.white,
          prefixIcon: icon != null ? Icon(icon, color: Colors.grey) : null,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: const Color.fromARGB(255, 39, 98, 146),
              width: 1.5,
            ),
          ),
        ),
      ),
    );
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
              padding: const EdgeInsets.only(left: 20, right: 200, top: 100),
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

            // Name Field
            // customTextFormField(
            //   controller: nameController,
            //   labelText: "Name",
            //   hintText: "Enter Name",
            //   icon: Icons.person,
            //   validator: (value) {
            //     if (value == null || value.trim().isEmpty) {
            //       return 'Name is required';
            //     } else if (value.length < 3) {
            //       return 'Name must be at least 3 characters';
            //     }
            //     return null;
            //   },
            // ),
            // // Email Field
            // customTextFormField(
            //   controller: emailController,
            //   labelText: "Email Address",
            //   hintText: "Enter Email",
            //   icon: Icons.email,
            //   keyboardType: TextInputType.emailAddress,
            //   validator: (value) {
            //     if (value == null || value.trim().isEmpty) {
            //       return 'Email is required';
            //     } else if (!RegExp(
            //       r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$',
            //     ).hasMatch(value)) {
            //       return 'Enter a valid email';
            //     }
            //     return null;
            //   },
            // ),
            // // Phone Field
            // customTextFormField(
            //   controller: phoneController,
            //   labelText: "Mobile Number",
            //   hintText: "Enter Mobile Number",
            //   icon: Icons.phone,
            //   keyboardType: TextInputType.phone,
            //   validator: (value) {
            //     if (value == null || value.trim().isEmpty) {
            //       return 'Phone number is required';
            //     } else if (!RegExp(r'^\d{10}$').hasMatch(value)) {
            //       return 'Enter a valid 10-digit number';
            //     }
            //     return null;
            //   },
            // ),
            // // Date of Birth Field
            // customTextFormField(
            //   controller: dateController,
            //   labelText: "Date Of Birth",
            //   hintText: "Enter Date of Birth",
            //   icon: Icons.calendar_today,
            //   readOnly: true,
            //   onTap: () => _selectDate(context),
            //   validator: (value) {
            //     if (value == null || value.isEmpty) {
            //       return 'Date of birth is required';
            //     }
            //     return null;
            //   },
            // ),
            // // Gender Selection
            Form(
              key: _formKey,
              child: Column(
                children: [
                  customTextFormField(
                    controller: nameController,
                    labelText: "Name",
                    hintText: "Enter Name",
                    icon: Icons.person,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Name is required';
                      } else if (value.length < 3) {
                        return 'Name must be at least 3 characters';
                      }
                      return null;
                    },
                  ),
                  customTextFormField(
                    controller: emailController,
                    labelText: "Email Address",
                    hintText: "Enter Email",
                    icon: Icons.email,
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
                  customTextFormField(
                    controller: phoneController,
                    labelText: "Mobile Number",
                    hintText: "Enter Mobile Number",
                    icon: Icons.phone,
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
                  customTextFormField(
                    controller: dateController,
                    labelText: "Date Of Birth",
                    hintText: "Enter Date of Birth",
                    icon: Icons.calendar_today,
                    readOnly: true,
                    onTap: () => _selectDate(context),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Date of birth is required';
                      }
                      return null;
                    },
                  ),
                  // add more fields or gender selection here if needed
                ],
              ),
            ),

            genderSelection(),
            SizedBox(height: 20),

            GestureDetector(
              onTap: () {
                if (_formKey.currentState!.validate()) {
                  // ✅ Form is valid — navigate
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SigninScreen()),
                  );
                } else {
                  // ❌ Invalid — show error
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please fix the errors in the form'),
                    ),
                  );
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20),
                child: Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color.fromARGB(255, 17, 144, 248),
                  ),
                  child: Center(
                    child: Text(
                      "Register",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
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
