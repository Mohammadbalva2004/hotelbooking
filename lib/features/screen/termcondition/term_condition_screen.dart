// import 'package:flutter/material.dart';

// class TermConditionScreen extends StatefulWidget {
//   const TermConditionScreen({super.key});

//   @override
//   State<TermConditionScreen> createState() => _TermConditionScreenState();
// }

// class _TermConditionScreenState extends State<TermConditionScreen> {
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
//           "Terms & Condition ",
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
//               "Condition of Uses",
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
//               "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like).",
//               textAlign: TextAlign.justify,
//               style: TextStyle(fontSize: 17, color: Colors.black),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

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
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 30),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Terms & Condition ",
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
      ),
      body: const SingleChildScrollView(child: TermConditionWidget()),
    );
  }
}
