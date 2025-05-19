import 'package:flutter/material.dart';
import 'package:hotelbooking/features/screen/auth/otp/otp_screen.dart';
import 'package:hotelbooking/features/widgets/commonappbar/custom_app_bar.dart';
import 'package:hotelbooking/features/widgets/commonbutton/common_buttom.dart';
import 'package:hotelbooking/features/widgets/commontextfromfild/Common_Text_FormField.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController numberController = TextEditingController();

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
            _buildHeaderText(),
            const SizedBox(height: 10),
            _buildIllustrationImage(),
            const SizedBox(height: 20),
            _buildPhoneNumberField(),
            _buildEmailField(),
            const SizedBox(height: 40),
            _buildContinueButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 120, top: 10),
          child: Text(
            "Forgot Password",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 10, right: 20),
          child: Text(
            "Select which contact details should we use to reset your password",
            style: TextStyle(fontSize: 17, color: Colors.grey),
          ),
        ),
      ],
    );
  }

  Widget _buildIllustrationImage() {
    return Image.asset(
      "assets/images/forgetimg.png",
      height: 300,
      width: double.infinity,
    );
  }

  Widget _buildPhoneNumberField() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: CommonTextFormField(
        //controller: phoneController,
        labelText: "Send otp via SMS",
        hintText: "Enter mobile number",
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
    );
  }

  Widget _buildEmailField() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: CommonTextFormField(
        controller: emailController,
        labelText: "Send otp via Email",
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
    );
  }

  Widget _buildContinueButton(BuildContext context) {
    return CustomButton(
      text: "Continue",
      width: double.infinity,
      onPressed: () {
        {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const OtpScreen()),
          );
        }
      },
    );
  }
}
