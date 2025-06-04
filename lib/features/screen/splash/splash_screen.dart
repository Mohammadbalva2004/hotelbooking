import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hotelbooking/features/screen/home/home_screen.dart';
import 'package:hotelbooking/features/screen/onboard/onboard_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), _checkLoginStatus);
  }

  Future<void> _checkLoginStatus() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String? token = await FirebaseMessaging.instance.getToken();

      print("FCM Token: $token");

      DocumentReference userDocRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid);
      DocumentSnapshot userDoc = await userDocRef.get();

      if (userDoc.exists) {
        await userDocRef.update({'fcm_token': token});
      } else {
        await userDocRef.set({'fcm_token': token});
      }

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
