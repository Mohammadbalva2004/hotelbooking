// import 'package:flutter/material.dart';

// class PolicyScreen extends StatefulWidget {
//   const PolicyScreen({super.key});

//   @override
//   State<PolicyScreen> createState() => _PolicyScreenState();
// }

// class _PolicyScreenState extends State<PolicyScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         centerTitle: true,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black, size: 30),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: const Text(
//           "Privacy Policy",
//           style: TextStyle(color: Colors.black, fontSize: 20),
//         ),
//       ),

//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(left: 10.0),
//             child: Text(
//               "Last Update : 25/6/2022",
//               style: TextStyle(fontSize: 18, color: Colors.grey),
//             ),
//           ),

//           Padding(
//             padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10),
//             child: Text(
//               "Please read these terms of service,carefully \nbefore using our app operated by us",
//               style: TextStyle(fontSize: 17, color: Colors.black),
//             ),
//           ),

//           Padding(
//             padding: const EdgeInsets.only(left: 10.0, top: 10),
//             child: Text(
//               "Privacy Policy",
//               style: TextStyle(
//                 fontSize: 21,
//                 color: Color.fromARGB(255, 17, 144, 248),
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),

//           Padding(
//             padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10),
//             child: Text(
//               "There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by Injected humour, or randomised words which don't look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isn't anything embarrassing hidden in the middle of text.",

//               textAlign: TextAlign.justify,
//               style: TextStyle(fontSize: 18, color: Colors.black),
//             ),
//           ),

//           Padding(
//             padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10),
//             child: Text(
//               "All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks. as necessary, making this the first true generator on the Internet. It uses a dictionary of over 200 Latin words, combined with a handful of model sentence structures, to generate Lorem Ipsum which looks reasonable.",
//               textAlign: TextAlign.justify,
//               style: TextStyle(fontSize: 18, color: Colors.black),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10),
//             child: Text(
//               "The generated Lorem Ipsum is therefore always free from repetition, injected humour, or non-characteristic words etc.",
//               textAlign: TextAlign.justify,
//               style: TextStyle(fontSize: 18, color: Colors.black),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:hotelbooking/features/widgets/commanappbar/custom_app_bar.dart';

class PolicyContentWidget extends StatelessWidget {
  const PolicyContentWidget({super.key});

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
            "Privacy Policy",
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
            "There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by Injected humour, or randomised words which don't look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isn't anything embarrassing hidden in the middle of text.",
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10),
          child: Text(
            "All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks. as necessary, making this the first true generator on the Internet. It uses a dictionary of over 200 Latin words, combined with a handful of model sentence structures, to generate Lorem Ipsum which looks reasonable.",
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10),
          child: Text(
            "The generated Lorem Ipsum is therefore always free from repetition, injected humour, or non-characteristic words etc.",
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
        ),
      ],
    );
  }
}

class PolicyScreen extends StatefulWidget {
  const PolicyScreen({super.key});

  @override
  State<PolicyScreen> createState() => _PolicyScreenState();
}

class _PolicyScreenState extends State<PolicyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        mainTitle: 'privacy Policy',
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
      body: const SingleChildScrollView(child: PolicyContentWidget()),
    );
  }
}
