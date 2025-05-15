import 'package:flutter/material.dart';
import 'package:hotelbooking/features/screen/auth/signin/signin_screen.dart';
import 'package:hotelbooking/features/widgets/commanappbar/custom_app_bar.dart';
import 'package:hotelbooking/features/widgets/commanbutton/comman_buttom.dart';
import 'package:hotelbooking/features/widgets/commantextfromfild/Common_Text_FormField.dart';

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  bool _obscureText = true;
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

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
            _buildPasswordImage(),
            _buildPasswordForm(),
            SizedBox(height: 20),
            _buildSaveButton(context),
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
          padding: EdgeInsets.only(left: 10.0, right: 50, top: 10),
          child: Text(
            "Enter New Password",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 10.0, top: 0, right: 120),
          child: Text(
            "Please enter new password",
            style: TextStyle(fontSize: 17, color: Colors.grey),
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildPasswordImage() {
    return Image.asset(
      "assets/images/newpassword1.png",
      height: 300,
      width: double.infinity,
    );
  }

  Widget _buildPasswordForm() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: CommonTextFormField(
            controller: passwordController,
            labelText: "New Password",
            hintText: "Enter New Password",
            obscureText: _obscureText,
            prefixIcon: const Icon(Icons.lock),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility_off : Icons.visibility,
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
        ),
        const SizedBox(height: 10),

        Padding(
          padding: const EdgeInsets.all(10.0),
          child: CommonTextFormField(
            controller: passwordController,
            labelText: "New Confirm Password",
            hintText: "Enter Confirm New Password",
            obscureText: _obscureText,
            prefixIcon: const Icon(Icons.lock),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility_off : Icons.visibility,
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
        ),
      ],
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return CustomButton(
      text: "Save",
      width: double.infinity,
      onPressed: () => _showSuccessDialog(context),
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
            width: 400,
            height: 500,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  "assets/images/password.png",
                  height: 230,
                  width: 170,
                ),
                const SizedBox(height: 20),
                const Text(
                  "Password Update \n Successfully",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Your password has been \n updated successfully",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, color: Colors.grey),
                ),
                const Spacer(),
                _buildBackToLoginButton(context),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBackToLoginButton(BuildContext context) {
    return CustomButton(
      text: "Back to Login",
      width: double.infinity,
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const SigninScreen()),
        );
      },
    );
  }
}
