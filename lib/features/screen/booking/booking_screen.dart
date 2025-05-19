import 'package:flutter/material.dart';
import 'package:hotelbooking/features/screen/home/home_screen.dart';
import 'package:hotelbooking/features/screen/profile/profile_screen.dart';
import 'package:hotelbooking/features/widgets/commonappbar/custom_app_bar.dart';
import 'package:hotelbooking/features/widgets/commonbottomnavbar/common_bottom_nav_bar.dart';
import 'package:hotelbooking/features/widgets/commonhotelcard/common_hotel_card.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  bool isUpcomingSelected = true;

  void _navigateToTab(BuildContext context, int index) {
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else if (index == 4) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ProfileScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        mainTitle: 'Booking',
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
      body: Column(
        children: [
          _buildTabSelector(),
          Expanded(
            child:
                isUpcomingSelected
                    ? BookingList(isUpcoming: true)
                    : BookingList(isUpcoming: false),
          ),
        ],
      ),
      bottomNavigationBar: CommonBottomNavBar(
        currentIndex: 2,
        onTap: (index) => _navigateToTab(context, index),
      ),
    );
  }

  Widget _buildTabSelector() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => isUpcomingSelected = true),
              child: Container(
                height: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: isUpcomingSelected ? Colors.blue : Colors.white,
                ),
                child: Center(
                  child: Text(
                    "Upcoming",
                    style: TextStyle(
                      color: isUpcomingSelected ? Colors.white : Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => isUpcomingSelected = false),
              child: Container(
                height: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: isUpcomingSelected ? Colors.white : Colors.blue,
                ),
                child: Center(
                  child: Text(
                    "Past",
                    style: TextStyle(
                      color: isUpcomingSelected ? Colors.black : Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BookingList extends StatelessWidget {
  final bool isUpcoming;

  const BookingList({super.key, required this.isUpcoming});

  @override
  Widget build(BuildContext context) {
    final List<BookingItem> bookings =
        isUpcoming
            ? [
              BookingItem(
                id: "22378965",
                date: "April 26, 2023, 10:00 PM - 03:00 PM",
                image: "assets/images/room1.png",
                rating: 5,
                reviewCount: 120,
                title: "Malon Greens",
                location: "Mumbai, Maharashtra",
              ),
              BookingItem(
                id: "90867891",
                date: "April 30, 2023, 10:00 PM - 03:00 PM",
                image: "assets/images/room3.png",
                rating: 4.5,
                reviewCount: 210,
                title: "Sabro Prime",
                location: "Goa, Maharashtra",
              ),
            ]
            : [
              BookingItem(
                id: "22378965",
                date: "April 20, 2023, 10:00 PM - 03:00 PM",
                image: "assets/images/room1.png",
                rating: 5,
                reviewCount: 120,
                title: "Malon Greens",
                location: "Mumbai, Maharashtra",
              ),
              BookingItem(
                id: "90867891",
                date: "April 15, 2023, 10:00 PM - 03:00 PM",
                image: "assets/images/room2.png",
                rating: 4,
                reviewCount: 95,
                title: "Paradise Mint",
                location: "Jaipur, Rajasthan",
              ),
            ];

    return ListView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        return BookingCard(booking: bookings[index], isUpcoming: isUpcoming);
      },
    );
  }
}

class BookingCard extends StatelessWidget {
  final BookingItem booking;
  final bool isUpcoming;

  const BookingCard({
    super.key,
    required this.booking,
    required this.isUpcoming,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 260,
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              "Booking ID: ${booking.id}",
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text(
              "Booking Date: ${booking.date}",
              style: const TextStyle(fontSize: 15, color: Colors.grey),
            ),
          ),
          CommonHotelCard(
            image: booking.image,
            name: booking.title,
            rating: booking.rating,
            reviewCount: booking.reviewCount,
            location: booking.location,
            cardType: CardType.compact,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10, top: 5),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color.fromARGB(255, 241, 239, 239),
                    ),
                    child: Center(
                      child: Text(
                        isUpcoming ? "Cancel" : "Write a Review",
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.blue,
                    ),
                    child: Center(
                      child: Text(
                        isUpcoming ? "View Details" : "Book Again",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BookingItem {
  final String id;
  final String date;
  final String image;
  final double rating;
  final int reviewCount;
  final String title;
  final String location;

  BookingItem({
    required this.id,
    required this.date,
    required this.image,
    required this.rating,
    required this.reviewCount,
    required this.title,
    required this.location,
  });
}
