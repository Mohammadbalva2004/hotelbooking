// import 'dart:io';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';

// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart'; // For picking images

// import 'package:hotelbooking/features/screen/auth/signin/signin_screen.dart';
// import 'package:hotelbooking/features/widgets/commonbutton/common_buttom.dart';
// import 'package:hotelbooking/features/widgets/commontextfromfild/Common_Text_FormField.dart';
// import 'package:intl/intl.dart';
// import 'package:path/path.dart' as path;

// void main() {
//   runApp(
//     const MaterialApp(debugShowCheckedModeBanner: false, home: SignupScreen()),
//   );
// }

// class SignupScreen extends StatefulWidget {
//   const SignupScreen({Key? key}) : super(key: key);

//   @override
//   State<SignupScreen> createState() => _SignupScreenState();
// }

// class _SignupScreenState extends State<SignupScreen> {
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController phoneController = TextEditingController();
//   final TextEditingController dateController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();

//   String? _selectedGender;
//   bool _obscureText = true;

//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//   String email = "";
//   String password = "";

//   File? _imageFile;
//   final ImagePicker picker = ImagePicker();

//   Future<String?> uploadProfileImage(File imageFile, String userId) async {
//     try {
//       final storageRef = FirebaseStorage.instance
//           .ref()
//           .child('profile_images')
//           .child('$userId.jpg');

//       UploadTask uploadTask = storageRef.putFile(imageFile);
//       TaskSnapshot snapshot = await uploadTask;

//       String downloadUrl = await snapshot.ref.getDownloadURL();
//       print("Uploaded Image URL: $downloadUrl");
//       return downloadUrl;
//     } catch (e) {
//       print("Image upload failed: $e");
//       return null;
//     }
//   }

//   Future<void> _pickImage() async {
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);

//     if (pickedFile != null) {
//       final extension = path.extension(pickedFile.path).toLowerCase();

//       // Allow only .jpg, .jpeg, .png, .svg
//       if (['.jpg', '.jpeg', '.png', '.svg'].contains(extension)) {
//         setState(() {
//           _imageFile = File(pickedFile.path);
//         });
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Only JPG, PNG, and SVG files are allowed.'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     }
//   }

//   Future<bool> registration() async {
//     try {
//       UserCredential userCredential = await FirebaseAuth.instance
//           .createUserWithEmailAndPassword(email: email, password: password);

//       User? user = userCredential.user;

//       if (user != null) {
//         String? imageUrl;
//         if (_imageFile != null) {
//           imageUrl = await uploadProfileImage(_imageFile!, user.uid);
//         }

//         await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
//           'name': nameController.text.trim(),
//           'email': emailController.text.trim(),
//           'phone': phoneController.text.trim(),
//           'dob': dateController.text.trim(),
//           'gender': _selectedGender ?? '',
//           'profileImage': imageUrl ?? '',
//         });

//         await user.sendEmailVerification();

//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             backgroundColor: Colors.green,
//             content: Text(
//               "Registered Successfully. Please verify your email.",
//               style: TextStyle(fontSize: 18, color: Colors.white),
//             ),
//           ),
//         );
//       }

//       return true;
//     } on FirebaseAuthException catch (e) {
//       String errorMessage = "Registration failed";
//       if (e.code == 'weak-password') {
//         errorMessage = "Password must be at least 6 characters long";
//       } else if (e.code == 'email-already-in-use') {
//         errorMessage = "Account already exists with this email";
//       } else if (e.message != null) {
//         errorMessage = e.message!;
//       }

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           backgroundColor: Colors.redAccent,
//           content: Text(
//             errorMessage,
//             style: const TextStyle(fontSize: 18, color: Colors.white),
//           ),
//         ),
//       );

//       return false;
//     }
//   }

//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime(2000),
//       firstDate: DateTime(1900),
//       lastDate: DateTime.now(),
//     );
//     if (picked != null) {
//       setState(() {
//         dateController.text = DateFormat('yyyy-MM-dd').format(picked);
//       });
//     }
//   }

//   Widget genderSelection() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 10.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             "Gender",
//             style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//           ),
//           RadioListTile<String>(
//             title: const Text('Male'),
//             value: 'Male',
//             groupValue: _selectedGender,
//             onChanged: (value) {
//               setState(() {
//                 _selectedGender = value;
//               });
//             },
//             dense: true,
//             contentPadding: EdgeInsets.zero,
//             visualDensity: const VisualDensity(
//               horizontal: VisualDensity.minimumDensity,
//               vertical: VisualDensity.minimumDensity,
//             ),
//             materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
//           ),
//           RadioListTile<String>(
//             title: const Text('Female'),
//             value: 'Female',
//             groupValue: _selectedGender,
//             onChanged: (value) {
//               setState(() {
//                 _selectedGender = value;
//               });
//             },
//             dense: true,
//             contentPadding: EdgeInsets.zero,
//             visualDensity: const VisualDensity(
//               horizontal: VisualDensity.minimumDensity,
//               vertical: VisualDensity.minimumDensity,
//             ),
//             materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             // Logo
//             Padding(
//               padding: const EdgeInsets.only(left: 20, right: 200, top: 50),
//               child: Image.asset("assets/images/splash.png"),
//             ),
//             // Title
//             Padding(
//               padding: const EdgeInsets.only(left: 20.0, right: 180, top: 30),
//               child: const Text(
//                 "Register Now!",
//                 style: TextStyle(
//                   fontSize: 25,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black,
//                 ),
//               ),
//             ),
//             // Subtitle
//             Padding(
//               padding: const EdgeInsets.only(left: 20.0, right: 140, top: 10),
//               child: const Text(
//                 "Enter your information below",
//                 style: TextStyle(fontSize: 15, color: Colors.grey),
//               ),
//             ),
//             const SizedBox(height: 20),

//             Stack(
//               children: [
//                 CircleAvatar(
//                   radius: 60,
//                   backgroundImage:
//                       _imageFile != null
//                           ? FileImage(_imageFile!)
//                           : const AssetImage('assets/images/default_avatar.png')
//                               as ImageProvider,
//                 ),
//                 Positioned(
//                   bottom: 0,
//                   right: 0,
//                   child: IconButton(
//                     icon: const Icon(Icons.camera_alt),
//                     onPressed: _pickImage,
//                   ),
//                 ),
//               ],
//             ),

//             Form(
//               key: _formKey,
//               child: Column(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: CommonTextFormField(
//                       controller: nameController,
//                       labelText: "Name",
//                       hintText: "Enter Name",
//                       prefixIcon: const Icon(Icons.person),
//                       validator: (value) {
//                         if (value == null || value.trim().isEmpty) {
//                           return 'Name is required';
//                         } else if (value.length < 3) {
//                           return 'Name must be at least 3 characters';
//                         }
//                         return null;
//                       },
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: CommonTextFormField(
//                       controller: emailController,
//                       labelText: "Email Address",
//                       hintText: "Enter Email",
//                       prefixIcon: const Icon(Icons.email),
//                       keyboardType: TextInputType.emailAddress,
//                       validator: (value) {
//                         if (value == null || value.trim().isEmpty) {
//                           return 'Email is required';
//                         } else if (!RegExp(
//                           r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$',
//                         ).hasMatch(value)) {
//                           return 'Enter a valid email';
//                         }
//                         return null;
//                       },
//                       onChanged: (val) {
//                         email = val;
//                       },
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: CommonTextFormField(
//                       controller: passwordController,
//                       labelText: "Password",
//                       hintText: "Enter Password",
//                       prefixIcon: const Icon(Icons.lock),
//                       obscureText: _obscureText,
//                       suffixIcon: IconButton(
//                         icon: Icon(
//                           _obscureText
//                               ? Icons.visibility_off
//                               : Icons.visibility,
//                           color: Colors.grey,
//                         ),
//                         onPressed: () {
//                           setState(() {
//                             _obscureText = !_obscureText;
//                           });
//                         },
//                       ),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Password is required';
//                         } else if (value.length < 6) {
//                           return 'Password must be at least 6 characters long';
//                         }
//                         return null;
//                       },
//                       onChanged: (val) {
//                         password = val;
//                       },
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: CommonTextFormField(
//                       controller: phoneController,
//                       labelText: "Mobile Number",
//                       hintText: "Enter Mobile Number",
//                       prefixIcon: const Icon(Icons.phone),
//                       keyboardType: TextInputType.phone,
//                       validator: (value) {
//                         if (value == null || value.trim().isEmpty) {
//                           return 'Phone number is required';
//                         } else if (!RegExp(r'^\d{10}$').hasMatch(value)) {
//                           return 'Enter a valid 10-digit number';
//                         }
//                         return null;
//                       },
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: CommonTextFormField(
//                       controller: dateController,
//                       labelText: "Date Of Birth",
//                       hintText: "Enter Date of Birth",
//                       prefixIcon: const Icon(Icons.calendar_today),
//                       readOnly: true,
//                       onTap: () => _selectDate(context),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Date of birth is required';
//                         }
//                         return null;
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             genderSelection(),
//             const SizedBox(height: 20),

//             CustomButton(
//               text: "Register",
//               width: double.infinity,
//               onPressed: () async {
//                 if (_formKey.currentState!.validate()) {
//                   // Update email and password from controllers (in case user edited last)
//                   setState(() {
//                     email = emailController.text.trim();
//                     password = passwordController.text.trim();
//                   });

//                   bool success = await registration();

//                   if (success) {
//                     Navigator.pushReplacement(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => const SigninScreen(),
//                       ),
//                     );
//                   }
//                 } else {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                       content: Text('Please fix the errors in the form'),
//                     ),
//                   );
//                 }
//               },
//             ),

//             const SizedBox(height: 30),
//             // Login Prompt
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Text(
//                   "Already a member? ",
//                   style: TextStyle(
//                     fontSize: 17,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black,
//                   ),
//                 ),
//                 GestureDetector(
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => const SigninScreen(),
//                       ),
//                     );
//                   },
//                   child: const Text(
//                     "Login",
//                     style: TextStyle(
//                       fontSize: 17,
//                       fontWeight: FontWeight.bold,
//                       color: Color.fromARGB(255, 28, 135, 223),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hotelbooking/features/screen/auth/signin/signin_screen.dart';
import 'package:hotelbooking/features/widgets/commonbutton/common_buttom.dart';
import 'package:hotelbooking/features/widgets/commontextfromfild/Common_Text_FormField.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;

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

  String email = "";
  String password = "";

  File? _imageFile;
  final ImagePicker picker = ImagePicker();

  Future<String?> uploadProfileImage(File imageFile, String userId) async {
    try {
      if (!imageFile.existsSync()) {
        print("Image file not avilabel");
        return null;
      }

      String fileName = path.basename(imageFile.path);

      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child('$userId/$fileName');

      print("Image upload ho rahi hai: profile_images/$userId/$fileName");

      UploadTask uploadTask = storageRef.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;

      String downloadUrl = await snapshot.ref.getDownloadURL();
      print("Image upload Successfully URL: $downloadUrl");

      return downloadUrl;
    } catch (e) {
      print("Image upload fail : $e");
      return null;
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final extension = path.extension(pickedFile.path).toLowerCase();

      if (['.jpg', '.jpeg', '.png', '.svg'].contains(extension)) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Only JPG, PNG, and SVG files are allowed.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      print("No image selected.");
    }
  }

  Future<bool> registration() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      User? user = userCredential.user;

      if (user != null) {
        String? imageUrl;
        if (_imageFile != null) {
          imageUrl = await uploadProfileImage(_imageFile!, user.uid);
        }

        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'name': nameController.text.trim(),
          'email': emailController.text.trim(),
          'phone': phoneController.text.trim(),
          'dob': dateController.text.trim(),
          'gender': _selectedGender ?? '',
          'profileImage': imageUrl ?? '',
        });

        await user.sendEmailVerification();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              "Registered Successfully. Please verify your email.",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        );
      }

      return true;
    } on FirebaseAuthException catch (e) {
      String errorMessage = "Registration failed";
      if (e.code == 'weak-password') {
        errorMessage = "Password must be at least 6 characters long";
      } else if (e.code == 'email-already-in-use') {
        errorMessage = "Account already exists with this email";
      } else if (e.message != null) {
        errorMessage = e.message!;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(
            errorMessage,
            style: const TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      );

      return false;
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
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 200, top: 50),
              child: Image.asset("assets/images/splash.png"),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20.0, right: 180, top: 30),
              child: Text(
                "Register Now!",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20.0, right: 140, top: 10),
              child: Text(
                "Enter your information below",
                style: TextStyle(fontSize: 15, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 20),
            Stack(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage:
                      _imageFile != null
                          ? FileImage(_imageFile!)
                          : const AssetImage('assets/images/default_avatar.png')
                              as ImageProvider,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: IconButton(
                    icon: const Icon(Icons.camera_alt),
                    onPressed: _pickImage,
                  ),
                ),
              ],
            ),
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
                      prefixIcon: const Icon(Icons.person),
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
                      prefixIcon: const Icon(Icons.email),
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
                      onChanged: (val) {
                        email = val;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CommonTextFormField(
                      controller: passwordController,
                      labelText: "Password",
                      hintText: "Enter Password",
                      prefixIcon: const Icon(Icons.lock),
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password is required';
                        } else if (value.length < 6) {
                          return 'Password must be at least 6 characters long';
                        }
                        return null;
                      },
                      onChanged: (val) {
                        password = val;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CommonTextFormField(
                      controller: phoneController,
                      labelText: "Mobile Number",
                      hintText: "Enter Mobile Number",
                      prefixIcon: const Icon(Icons.phone),
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
                      prefixIcon: const Icon(Icons.calendar_today),
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
                ],
              ),
            ),
            genderSelection(),
            const SizedBox(height: 20),
            CustomButton(
              text: "Register",
              width: double.infinity,
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    email = emailController.text.trim();
                    password = passwordController.text.trim();
                  });

                  bool success = await registration();

                  if (success) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SigninScreen(),
                      ),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fix the errors in the form'),
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
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
                      MaterialPageRoute(
                        builder: (context) => const SigninScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 28, 135, 223),
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
