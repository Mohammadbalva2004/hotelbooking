import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hotelbooking/features/screen/auth/newpassword/New_password_screen.dart';
import 'package:hotelbooking/features/widgets/commanappbar/custom_app_bar.dart';
import 'package:hotelbooking/features/widgets/commanbutton/comman_buttom.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  int _timerSeconds = 30;
  late Timer _timer;
  final List<TextEditingController> _otpControllers = List.generate(
    4,
    (index) => TextEditingController(),
  );

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timerSeconds > 0) {
        setState(() {
          _timerSeconds--;
        });
      } else {
        _timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        leadingIcon: Icons.arrow_back_ios,
        onLeadingTap: () => Navigator.pop(context),
        elevation: 2,
        height: 60,
        leadingIconColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            _buildOtpInputFields(),
            _buildResendCodeText(),
            _buildOtpImage(),
            _buildVerifyButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 20.0, right: 120, top: 10),
          child: Text(
            "Enter OTP Code",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 20.0, top: 10, right: 50),
          child: Text(
            "OTP Code has been sent to (409)555-0120",
            style: TextStyle(fontSize: 15, color: Colors.grey),
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildOtpInputFields() {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(4, (index) => _buildOtpField(index)),
      ),
    );
  }

  Widget _buildOtpField(int index) {
    return SizedBox(
      height: 70,
      width: 60,
      child: TextFormField(
        controller: _otpControllers[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        decoration: InputDecoration(
          counterText: "",
          floatingLabelBehavior: FloatingLabelBehavior.always,
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Color.fromARGB(255, 39, 98, 146),
              width: 1.5,
            ),
          ),
        ),
        onChanged: (value) {
          if (value.length == 1 && index < 3) {
            FocusScope.of(context).nextFocus();
          }
        },
      ),
    );
  }

  Widget _buildResendCodeText() {
    return Padding(
      padding: const EdgeInsets.only(right: 50.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            _timerSeconds > 0 ? "Resend in $_timerSeconds sec" : "Resend Code",
            style: TextStyle(
              fontSize: 15,
              color: _timerSeconds > 0 ? Colors.blue : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOtpImage() {
    return Column(
      children: [
        const SizedBox(height: 60),
        Image.asset(
          "assets/images/otp2.png",
          height: 300,
          width: double.infinity,
        ),
        const SizedBox(height: 80),
      ],
    );
  }

  Widget _buildVerifyButton(BuildContext context) {
    return CustomButton(
      text: "Verify",
      onPressed: () {
        // Validate OTP before navigation
        final otp = _otpControllers.map((c) => c.text).join();
        if (otp.length == 4) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NewPasswordScreen()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Please enter complete OTP")),
          );
        }
      },
    );
  }
}
