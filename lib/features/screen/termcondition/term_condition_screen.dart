import 'package:flutter/material.dart';
import 'package:hotelbooking/features/widgets/commanappbar/custom_app_bar.dart';

class TermConditionWidget extends StatelessWidget {
  const TermConditionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Text(
            "Last Update : 25/6/2022",
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10),
          child: Text(
            "Please read these terms of service,carefully \nbefore using our app operated by us",
            style: TextStyle(fontSize: 17, color: Colors.black),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10.0, top: 10),
          child: Text(
            "Condition of Uses",
            style: TextStyle(
              fontSize: 21,
              color: Color.fromARGB(255, 17, 144, 248),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10),
          child: Text(
            "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like).",
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
        ),
      ],
    );
  }
}

class TermConditionScreen extends StatefulWidget {
  const TermConditionScreen({super.key});

  @override
  State<TermConditionScreen> createState() => _TermConditionScreenState();
}

class _TermConditionScreenState extends State<TermConditionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        mainTitle: 'Terms & Conditions',
        leadingIcon: Icons.arrow_back_ios,
        onLeadingTap: () => Navigator.pop(context),
        elevation: 2,
        height: 60,
        leadingIconColor: Colors.black,

        mainTitleStyle: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      body: const SingleChildScrollView(child: TermConditionWidget()),
    );
  }
}
