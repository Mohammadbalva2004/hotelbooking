// // import 'package:flutter/material.dart';
// // import 'package:hotelbooking/features/screen/splash/splash_screen.dart';
// // import 'package:firebase_core/firebase_core.dart';
// // import 'firebase_options.dart';
// // import 'package:firebase_messaging/firebase_messaging.dart';

// // void main() async {
// //   WidgetsFlutterBinding.ensureInitialized();
// //   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
// //   await FirebaseMessaging.instance.requestPermission();

// //   runApp(const MyApp());
// // }

// // class MyApp extends StatelessWidget {
// //   const MyApp({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       debugShowCheckedModeBanner: false,
// //       home: const SplashScreen(),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:hotelbooking/features/screen/home/home_screen.dart';
// import 'package:hotelbooking/features/screen/onboard/onboard_screen.dart';
// import 'firebase_options.dart';

// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   await FirebaseMessaging.instance.requestPermission();
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       home: SplashScreen(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     _checkAuthAndNavigate();
//   }

//   Future<void> _checkAuthAndNavigate() async {
//     await Future.delayed(const Duration(seconds: 3)); // Show splash for 2 sec

//     User? user = FirebaseAuth.instance.currentUser;

//     if (user != null) {
//       await _saveFcmToken(user);
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => const HomeScreen()),
//       );
//     } else {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => const OnboardScreen()),
//       );
//     }
//   }

//   Future<void> _saveFcmToken(User user) async {
//     final token = await FirebaseMessaging.instance.getToken();
//     if (token == null) return;

//     final userDoc = FirebaseFirestore.instance
//         .collection('users')
//         .doc(user.uid);
//     int attempts = 0;

//     while (attempts < 3) {
//       try {
//         final doc = await userDoc.get();
//         if (doc.exists) {
//           await userDoc.update({'fcmToken': token});
//         } else {
//           await userDoc.set({'fcmToken': token}, SetOptions(merge: true));
//         }
//         print("✅ FCM Token saved successfully: $token");
//         break;
//       } catch (e) {
//         attempts++;
//         print("⚠️ Firestore write failed. Attempt $attempts. Error: $e");
//         await Future.delayed(Duration(seconds: 2 * attempts));
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.asset('assets/images/splash.png'),
//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hotelbooking/features/screen/home/home_screen.dart';
import 'package:hotelbooking/features/screen/onboard/onboard_screen.dart';
import 'firebase_options.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseMessaging.instance.requestPermission();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    await Future.delayed(const Duration(seconds: 3));

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await _saveFcmToken(user);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OnboardScreen()),
      );
    }
  }

  Future<void> _saveFcmToken(User user) async {
    final token = await FirebaseMessaging.instance.getToken();
    if (token == null) return;

    final userDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid);
    int attempts = 0;

    while (attempts < 3) {
      try {
        final doc = await userDoc.get();
        if (doc.exists) {
          await userDoc.update({'fcmToken': token});
        } else {
          await userDoc.set({'fcmToken': token}, SetOptions(merge: true));
        }
        print(" FCM Token saved successfully: $token");
        break;
      } catch (e) {
        attempts++;
        print(" Firestore write failed. Attempt $attempts. Error: $e");
        await Future.delayed(Duration(seconds: 2 * attempts));
      }
    }
  }

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
