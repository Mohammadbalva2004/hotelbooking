// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:hotelbooking/features/screen/home/home_screen.dart';
// import 'package:hotelbooking/features/screen/onboard/onboard_screen.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Future.delayed(const Duration(seconds: 3), () async {
//         await checkLoginStatus();
//       });
//     });
//   }

//   Future<void> checkLoginStatus() async {
//     User? user = FirebaseAuth.instance.currentUser;
//     print("User: $user");

//     if (user != null) {
//       await saveTokenToFirestore(user);
//     }

//     if (!mounted) return;

//     if (user != null) {
//       print("Navigating to HomeScreen");
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => const HomeScreen()),
//       );
//     } else {
//       print("Navigating to OnboardScreen");
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => const OnboardScreen()),
//       );
//     }
//   }

//   Future<void> saveTokenToFirestore(User user) async {
//     try {
//       String? token = await FirebaseMessaging.instance.getToken();
//       if (token != null) {
//         await FirebaseFirestore.instance
//             .collection('users')
//             .doc(user.uid)
//             .update({'fcmToken': token});
//         print("FCM Token saved: $token");
//       }
//     } catch (e) {
//       print("Failed to save token: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.asset("assets/images/splash.png"),
//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }
// }

// //   void whereToGo() async {
// //     var sharedPref = await SharedPreferences.getInstance();

// //     var isLoggedIn = sharedPref.getBool(KEYLOGIN);

// //     Future.delayed(const Duration(seconds: 3), () {
// //       if (isLoggedIn != null) {
// //         if (isLoggedIn) {
// //           Navigator.pushReplacement(
// //             context,
// //             MaterialPageRoute(builder: (context) => const HomeScreen()),
// //           );
// //         } else {
// //           Navigator.pushReplacement(
// //             context,
// //             MaterialPageRoute(builder: (context) => const SigninScreen()),
// //           );
// //         }
// //       } else {
// //         Navigator.pushReplacement(
// //           context,
// //           MaterialPageRoute(builder: (context) => const OnboardScreen()),
// //         );
// //       }
// //     });
// //   }
// // }
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/splash.png'),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
