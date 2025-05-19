// import 'package:flutter/material.dart';

// class ReviewScreen extends StatefulWidget {
//   const ReviewScreen({super.key});

//   @override
//   State<ReviewScreen> createState() => _ReviewScreenState();
// }

// class _ReviewScreenState extends State<ReviewScreen> {
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
//           "Reviews ",
//           style: TextStyle(
//             color: Colors.black,
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//       body: Column(
//         children: [
//           Row(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.only(left: 15.0, top: 10),
//                 child: Text(
//                   "5.0",
//                   style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
//                 ),
//               ),
//               SizedBox(width: 10),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   StarRating(rating: 4.5, iconSize: 30),
//                   StarRating(reviewCount: 120),
//                 ],
//               ),
//             ],
//           ),

//           SizedBox(height: 20),

//           Padding(
//             padding: const EdgeInsets.all(10.0),
//             child: Column(
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     ClipRRect(
//                       borderRadius: BorderRadius.circular(10),
//                       child: Image.asset(
//                         "assets/images/person1.jpg",
//                         height: 60,
//                         width: 60,
//                         fit: BoxFit.cover,
//                       ),
//                     ),

//                     Padding(
//                       padding: const EdgeInsets.only(left: 10.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "Savannah Nguyen",
//                             style: TextStyle(
//                               fontSize: 20,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           Text(
//                             "05 May ,2023",
//                             style: TextStyle(
//                               fontSize: 17,
//                               //fontWeight: FontWeight.bold,
//                               color: Colors.grey,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),

//                     StarRating(rating: 5, iconSize: 25),
//                   ],
//                 ),
//                 SizedBox(height: 10),

//                 Padding(
//                   padding: const EdgeInsets.only(left: 70.0, right: 15),
//                   child: Text(
//                     "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout.",

//                     textAlign: TextAlign.justify,
//                     style: TextStyle(fontSize: 15),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const Padding(
//             padding: EdgeInsets.only(left: 15.0, right: 15),
//             child: Divider(color: Colors.grey, thickness: 1),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(10.0),
//             child: Column(
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     ClipRRect(
//                       borderRadius: BorderRadius.circular(10),
//                       child: Image.asset(
//                         "assets/images/person2.jpg",
//                         height: 60,
//                         width: 60,
//                         fit: BoxFit.cover,
//                       ),
//                     ),

//                     Padding(
//                       padding: const EdgeInsets.only(left: 10.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "Niraj goyat",
//                             style: TextStyle(
//                               fontSize: 20,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           Text(
//                             "06 May ,2023",
//                             style: TextStyle(
//                               fontSize: 17,
//                               //fontWeight: FontWeight.bold,
//                               color: Colors.grey,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),

//                     StarRating(rating: 5, iconSize: 25),
//                   ],
//                 ),
//                 SizedBox(height: 10),

//                 Padding(
//                   padding: const EdgeInsets.only(left: 70.0, right: 15),
//                   child: Text(
//                     "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout.",

//                     textAlign: TextAlign.justify,
//                     style: TextStyle(fontSize: 15),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const Padding(
//             padding: EdgeInsets.only(left: 15.0, right: 15),
//             child: Divider(color: Colors.grey, thickness: 1),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(10.0),
//             child: Column(
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     ClipRRect(
//                       borderRadius: BorderRadius.circular(10),
//                       child: Image.asset(
//                         "assets/images/person3.jpg",
//                         height: 60,
//                         width: 60,
//                         fit: BoxFit.cover,
//                       ),
//                     ),

//                     Padding(
//                       padding: const EdgeInsets.only(left: 10.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "Wade Warren",
//                             style: TextStyle(
//                               fontSize: 20,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           Text(
//                             "04 May ,2023",
//                             style: TextStyle(
//                               fontSize: 17,
//                               //fontWeight: FontWeight.bold,
//                               color: Colors.grey,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),

//                     StarRating(rating: 5, iconSize: 25),
//                   ],
//                 ),
//                 SizedBox(height: 10),

//                 Padding(
//                   padding: const EdgeInsets.only(left: 70.0, right: 15),
//                   child: Text(
//                     "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout.",

//                     textAlign: TextAlign.justify,
//                     style: TextStyle(fontSize: 15),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class StarRating extends StatelessWidget {
//   final double? rating;
//   final int? reviewCount;
//   final double iconSize;

//   const StarRating({
//     super.key,
//     this.rating,
//     this.reviewCount,
//     this.iconSize = 20, // default to 20 if not provided
//   });

//   @override
//   Widget build(BuildContext context) {
//     if (rating == null) {
//       return Row(
//         children: [
//           if (reviewCount != null)
//             Text(
//               "($reviewCount reviews)",
//               style: const TextStyle(fontSize: 17, color: Colors.grey),
//             ),
//         ],
//       );
//     }

//     final fullStars = rating!.floor();
//     final bool hasHalfStar = rating! - fullStars >= 0.5;

//     return Row(
//       children: [
//         ...List.generate(
//           fullStars,
//           (index) => Icon(Icons.star, color: Colors.amber, size: iconSize),
//         ),
//         if (hasHalfStar)
//           Icon(Icons.star_half, color: Colors.amber, size: iconSize),
//         ...List.generate(
//           5 - fullStars - (hasHalfStar ? 1 : 0),
//           (index) =>
//               Icon(Icons.star_border, color: Colors.amber, size: iconSize),
//         ),
//         if (reviewCount != null) ...[
//           const SizedBox(width: 5),
//           Text(
//             "($reviewCount reviews)",
//             style: const TextStyle(fontSize: 17, color: Colors.black),
//           ),
//         ],
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:hotelbooking/features/widgets/commonappbar/custom_app_bar.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        mainTitle: 'Reviews',
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Rating Summary
            _buildRatingSummary(),

            // Reviews List
            _buildReviewItem(
              imagePath: "assets/images/person1.jpg",
              name: "Savannah Nguyen",
              date: "05 May, 2023",
              rating: 5,
              reviewText:
                  "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout.",
            ),

            _buildReviewItem(
              imagePath: "assets/images/person2.jpg",
              name: "Niraj goyat",
              date: "06 May, 2023",
              rating: 5,
              reviewText:
                  "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout.",
            ),

            _buildReviewItem(
              imagePath: "assets/images/person3.jpg",
              name: "Wade Warren",
              date: "04 May, 2023",
              rating: 5,
              reviewText:
                  "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout.",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingSummary() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
      child: Row(
        children: [
          const Text(
            "5.0",
            style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StarRating(rating: 4.5, iconSize: 30),
              StarRating(reviewCount: 120),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReviewItem({
    required String imagePath,
    required String name,
    required String date,
    required double rating,
    required String reviewText,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      imagePath,
                      height: 60,
                      width: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            date,
                            style: const TextStyle(
                              fontSize: 17,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  StarRating(rating: rating, iconSize: 25),
                ],
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 70.0, right: 15),
                child: Text(
                  reviewText,
                  textAlign: TextAlign.justify,
                  style: const TextStyle(fontSize: 15),
                ),
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 15.0, right: 15),
          child: Divider(color: Colors.grey, thickness: 1),
        ),
      ],
    );
  }
}

class StarRating extends StatelessWidget {
  final double? rating;
  final int? reviewCount;
  final double iconSize;

  const StarRating({
    super.key,
    this.rating,
    this.reviewCount,
    this.iconSize = 20,
  });

  @override
  Widget build(BuildContext context) {
    if (rating == null) {
      return Row(
        children: [
          if (reviewCount != null)
            Text(
              "($reviewCount reviews)",
              style: const TextStyle(fontSize: 17, color: Colors.grey),
            ),
        ],
      );
    }

    final fullStars = rating!.floor();
    final bool hasHalfStar = rating! - fullStars >= 0.5;

    return Row(
      children: [
        ...List.generate(
          fullStars,
          (index) => Icon(Icons.star, color: Colors.amber, size: iconSize),
        ),
        if (hasHalfStar)
          Icon(Icons.star_half, color: Colors.amber, size: iconSize),
        ...List.generate(
          5 - fullStars - (hasHalfStar ? 1 : 0),
          (index) =>
              Icon(Icons.star_border, color: Colors.amber, size: iconSize),
        ),
        if (reviewCount != null) ...[
          const SizedBox(width: 5),
          Text(
            "($reviewCount reviews)",
            style: const TextStyle(fontSize: 17, color: Colors.black),
          ),
        ],
      ],
    );
  }
}
