import 'package:flutter/material.dart';
import 'package:hotelbooking/features/screen/auth/forgotpassword/forgot_password_screen.dart';
import 'package:hotelbooking/features/screen/auth/signup/signup_screen.dart';
import 'package:hotelbooking/features/screen/home/home_screen.dart';
import 'package:hotelbooking/features/widgets/commonbutton/common_buttom.dart';
import 'package:hotelbooking/features/widgets/commontextfromfild/Common_Text_FormField.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hotelbooking/features/screen/splash/splash_screen.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscureText = true;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 100),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 200),
              child: Image.asset("assets/images/splash.png"),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20.0, right: 120, top: 30),
              child: Text(
                "Let's get you Login!",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
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
            const SocialLoginRow(),
            const SizedBox(height: 10),
            const DividerWithText(),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    CommonTextFormField(
                      controller: emailController,
                      labelText: "Email Address",
                      hintText: "Enter Email",
                      prefixIcon: const Icon(Icons.email),
                      obscureText: false,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Email is required';
                        } else if (!RegExp(
                          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                        ).hasMatch(value.trim())) {
                          return 'Enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    CommonTextFormField(
                      controller: passwordController,
                      labelText: "Password",
                      hintText: "Enter Password",
                      obscureText: _obscureText,
                      prefixIcon: const Icon(Icons.lock),
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
                        if (value == null || value.trim().isEmpty) {
                          return 'Password is required';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ForgotPasswordScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      "Forgot Password ?",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 28, 135, 223),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 35),
            CustomButton(
              text: "Login",
              width: double.infinity,
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  var sharedPref = await SharedPreferences.getInstance();
                  sharedPref.setBool(
                    SplashScreenState.KEYLOGIN,
                    true,
                  ); // <-- This will now work

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
                } else {
                  print('Form is not valid');
                }
              },
            ),

            const SizedBox(height: 100),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Don't have an account ? ",
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
                        builder: (context) => const SignupScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    "Register Now ",
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

// Social login row
class SocialLoginRow extends StatelessWidget {
  const SocialLoginRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(
          child: SocialButton(image: "assets/icon/google.png", text: "Google"),
        ),
        Expanded(
          child: SocialButton(
            image: "assets/icon/facebook.png",
            text: "Facebook",
          ),
        ),
      ],
    );
  }
}

class SocialButton extends StatelessWidget {
  final String image;
  final String text;

  const SocialButton({super.key, required this.image, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          border: Border.all(color: Colors.grey, width: 2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [Image.asset(image, height: 30, width: 30), Text(text)],
        ),
      ),
    );
  }
}

// Divider with text
class DividerWithText extends StatelessWidget {
  const DividerWithText({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        children: const <Widget>[
          Expanded(
            child: Divider(color: Colors.grey, thickness: 1, endIndent: 10),
          ),
          Text(
            "Or Login with",
            style: TextStyle(fontSize: 15, color: Colors.black),
          ),
          Expanded(
            child: Divider(color: Colors.grey, thickness: 1, indent: 10),
          ),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:hotelbooking/features/screen/auth/forgotpassword/forgot_password_screen.dart';
// import 'package:hotelbooking/features/screen/auth/signup/signup_screen.dart';
// import 'package:hotelbooking/features/screen/home/home_screen.dart';

// class SigninScreen extends StatefulWidget {
//   const SigninScreen({super.key});

//   @override
//   State<SigninScreen> createState() => _SigninScreenState();
// }

// class _SigninScreenState extends State<SigninScreen> {
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   bool _obscureText = true;
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   bool _isLoading = false;

//   void _signIn() async {
//     if (!_formKey.currentState!.validate()) return;

//     setState(() => _isLoading = true);

//     try {
//       await _auth.signInWithEmailAndPassword(
//         email: emailController.text.trim(),
//         password: passwordController.text.trim(),
//       );

//       // Navigate to HomeScreen if successful
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const HomeScreen()),
//       );
//     } on FirebaseAuthException catch (e) {
//       String message = "An error occurred";
//       if (e.code == 'user-not-found') {
//         message = 'No user found for that email.';
//       } else if (e.code == 'wrong-password') {
//         message = 'Wrong password provided.';
//       }

//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text(message)));
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             const SizedBox(height: 100),
//             Padding(
//               padding: const EdgeInsets.only(left: 20, right: 200),
//               child: Image.asset("assets/images/splash.png"),
//             ),
//             const Padding(
//               padding: EdgeInsets.only(left: 20.0, right: 120, top: 30),
//               child: Text(
//                 "Let's get you Login!",
//                 style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
//               ),
//             ),
//             const Padding(
//               padding: EdgeInsets.only(left: 20.0, right: 140, top: 10),
//               child: Text(
//                 "Enter your information below",
//                 style: TextStyle(fontSize: 15, color: Colors.grey),
//               ),
//             ),
//             const SizedBox(height: 20),
//             const SocialLoginRow(),
//             const SizedBox(height: 10),
//             const DividerWithText(),
//             const SizedBox(height: 20),
//             Form(
//               key: _formKey,
//               child: Column(
//                 children: [
//                   CustomTextField(
//                     controller: emailController,
//                     labelText: "Email Address",
//                     hintText: "Enter Email",
//                     prefixIcon: Icons.email,
//                     obscureText: false,
//                     validator: (value) {
//                       if (value == null || value.trim().isEmpty) {
//                         return 'Email is required';
//                       } else if (!RegExp(
//                         r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
//                       ).hasMatch(value.trim())) {
//                         return 'Enter a valid email';
//                       }
//                       return null;
//                     },
//                   ),
//                   CustomTextField(
//                     controller: passwordController,
//                     labelText: "Password",
//                     hintText: "Enter Password",
//                     prefixIcon: Icons.lock,
//                     obscureText: _obscureText,
//                     suffixIcon: IconButton(
//                       icon: Icon(
//                         _obscureText ? Icons.visibility_off : Icons.visibility,
//                         color: Colors.grey,
//                       ),
//                       onPressed: () {
//                         setState(() => _obscureText = !_obscureText);
//                       },
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Password is required';
//                       } else if (value.length < 6) {
//                         return 'Password must be at least 6 characters';
//                       }
//                       return null;
//                     },
//                   ),
//                 ],
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(right: 15.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const ForgotPasswordScreen(),
//                         ),
//                       );
//                     },
//                     child: const Text(
//                       "Forgot Password ?",
//                       style: TextStyle(
//                         fontSize: 17,
//                         fontWeight: FontWeight.bold,
//                         color: Color.fromARGB(255, 28, 135, 223),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 35),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   minimumSize: const Size.fromHeight(50),
//                   backgroundColor: const Color.fromARGB(255, 17, 144, 248),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//                 onPressed: _isLoading ? null : _signIn,
//                 child:
//                     _isLoading
//                         ? const CircularProgressIndicator(color: Colors.white)
//                         : const Text(
//                           "Login",
//                           style: TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                         ),
//               ),
//             ),
//             const SizedBox(height: 100),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Text(
//                   "Don't have an account ? ",
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
//                         builder: (context) => const SignupScreen(),
//                       ),
//                     );
//                   },
//                   child: const Text(
//                     "Register Now ",
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

// // Reusable TextField Widget
// class CustomTextField extends StatelessWidget {
//   final TextEditingController controller;
//   final String labelText;
//   final String hintText;
//   final IconData prefixIcon;
//   final bool obscureText;
//   final Widget? suffixIcon;
//   final String? Function(String?)? validator;

//   const CustomTextField({
//     super.key,
//     required this.controller,
//     required this.labelText,
//     required this.hintText,
//     required this.prefixIcon,
//     required this.obscureText,
//     this.suffixIcon,
//     this.validator,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(10.0),
//       child: TextFormField(
//         controller: controller,
//         obscureText: obscureText,
//         validator: validator,
//         decoration: InputDecoration(
//           labelText: labelText,
//           hintText: hintText,
//           filled: true,
//           fillColor: Colors.white,
//           prefixIcon: Icon(prefixIcon, color: Colors.grey),
//           suffixIcon: suffixIcon,
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10),
//             borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10),
//             borderSide: const BorderSide(color: Color(0xFF276292), width: 1.5),
//           ),
//         ),
//       ),
//     );
//   }
// }

// // Social login row
// class SocialLoginRow extends StatelessWidget {
//   const SocialLoginRow({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: const [
//         Expanded(
//           child: SocialButton(image: "assets/icon/google.png", text: "Google"),
//         ),
//         Expanded(
//           child: SocialButton(
//             image: "assets/icon/facebook.png",
//             text: "Facebook",
//           ),
//         ),
//       ],
//     );
//   }
// }

// class SocialButton extends StatelessWidget {
//   final String image;
//   final String text;

//   const SocialButton({super.key, required this.image, required this.text});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(10.0),
//       child: Container(
//         height: 70,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10),
//           color: Colors.white,
//           border: Border.all(color: Colors.grey, width: 2),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [Image.asset(image, height: 30, width: 30), Text(text)],
//         ),
//       ),
//     );
//   }
// }

// // Divider with text
// class DividerWithText extends StatelessWidget {
//   const DividerWithText({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 10.0),
//       child: Row(
//         children: const <Widget>[
//           Expanded(
//             child: Divider(color: Colors.grey, thickness: 1, endIndent: 10),
//           ),
//           Text(
//             "Or Login with",
//             style: TextStyle(fontSize: 15, color: Colors.black),
//           ),
//           Expanded(
//             child: Divider(color: Colors.grey, thickness: 1, indent: 10),
//           ),
//         ],
//       ),
//     );
//   }
// }
