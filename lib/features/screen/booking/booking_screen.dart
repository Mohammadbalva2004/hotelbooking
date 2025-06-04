import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hotelbooking/features/screen/home/home_screen.dart';
import 'package:hotelbooking/features/screen/profile/profile_screen.dart';
import 'package:hotelbooking/features/widgets/commonappbar/custom_app_bar.dart';
import 'package:hotelbooking/features/widgets/commonbottomnavbar/common_bottom_nav_bar.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  bool isUpcomingSelected = true;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
                    ? BookingList(
                      isUpcoming: true,
                      userId: _auth.currentUser?.uid ?? '',
                    )
                    : BookingList(
                      isUpcoming: false,
                      userId: _auth.currentUser?.uid ?? '',
                    ),
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
  final String userId;

  const BookingList({
    super.key,
    required this.isUpcoming,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    print('Fetching bookings for user: $userId, isUpcoming: $isUpcoming');

    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance
              .collection('bookings')
              .where('userId', isEqualTo: userId)
              .snapshots(),
      builder: (context, snapshot) {
        // Debug prints
        print('Connection state: ${snapshot.connectionState}');
        print('Has data: ${snapshot.hasData}');
        print('Error: ${snapshot.error}');

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          print('Error fetching bookings: ${snapshot.error}');
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 80, color: Colors.red[400]),
                const SizedBox(height: 16),
                Text(
                  "Error loading bookings",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Please try again later",
                  style: TextStyle(fontSize: 16, color: Colors.grey[500]),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Trigger rebuild
                    (context as Element).markNeedsBuild();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          print('No bookings found');
          return _buildEmptyState();
        }

        print('Document count: ${snapshot.data!.docs.length}');

        // Filter bookings based on upcoming/past
        final allBookings =
            snapshot.data!.docs.map((doc) {
              print('Document ID: ${doc.id}');
              print('Document data: ${doc.data()}');
              return BookingItem.fromFirestore(doc);
            }).toList();

        // Filter bookings based on status and dates
        final filteredBookings =
            allBookings.where((booking) {
              if (isUpcoming) {
                // Show confirmed and pending bookings
                return booking.status == 'confirmed' ||
                    booking.status == 'pending';
              } else {
                // Show completed and cancelled bookings
                return booking.status == 'completed' ||
                    booking.status == 'cancelled';
              }
            }).toList();

        print('Filtered bookings count: ${filteredBookings.length}');

        if (filteredBookings.isEmpty) {
          return _buildEmptyState();
        }

        return ListView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: filteredBookings.length,
          itemBuilder: (context, index) {
            return BookingCard(
              booking: filteredBookings[index],
              isUpcoming: isUpcoming,
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isUpcoming ? Icons.upcoming : Icons.history,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            isUpcoming ? "No Upcoming Bookings" : "No Past Bookings",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isUpcoming
                ? "Your future bookings will appear here"
                : "Your completed bookings will appear here",
            style: TextStyle(fontSize: 16, color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
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
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
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
          // Header with Booking ID and Status
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: _getStatusColor(booking.status).withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Booking ID: ${booking.id}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${booking.checkInDate} - ${booking.checkOutDate}",
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(booking.status),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    booking.status.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Hotel Information
          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child:
                      booking.hotelImage.startsWith('http')
                          ? Image.network(
                            booking.hotelImage,
                            height: 80,
                            width: 80,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, error, stackTrace) => Container(
                                  height: 80,
                                  width: 80,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(
                                    Icons.hotel,
                                    size: 40,
                                    color: Colors.grey,
                                  ),
                                ),
                          )
                          : Image.asset(
                            booking.hotelImage,
                            height: 80,
                            width: 80,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, error, stackTrace) => Container(
                                  height: 80,
                                  width: 80,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(
                                    Icons.hotel,
                                    size: 40,
                                    color: Colors.grey,
                                  ),
                                ),
                          ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.hotelName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 16,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              booking.hotelLocation,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          ...List.generate(
                            booking.hotelRating.floor(),
                            (index) => const Icon(
                              Icons.star,
                              size: 16,
                              color: Colors.amber,
                            ),
                          ),
                          if (booking.hotelRating -
                                  booking.hotelRating.floor() >=
                              0.5)
                            const Icon(
                              Icons.star_half,
                              size: 16,
                              color: Colors.amber,
                            ),
                          const SizedBox(width: 4),
                          Text(
                            "(${booking.hotelReviewCount} reviews)",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Booking Details
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                // Check-in and Check-out
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Check-in",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            booking.checkInDate,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            booking.checkInTime,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "${booking.nights} Night${booking.nights > 1 ? 's' : ''}",
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            "Check-out",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            booking.checkOutDate,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            booking.checkOutTime,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),
                const Divider(height: 1),
                const SizedBox(height: 15),

                // Guest Information
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Guests:",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _formatGuestInfo(booking),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // Price Breakdown
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "\$${booking.pricePerNight.toStringAsFixed(2)} × ${booking.nights} night${booking.nights > 1 ? 's' : ''}",
                          style: const TextStyle(fontSize: 14),
                        ),
                        Text(
                          "\$${(booking.pricePerNight * booking.nights).toStringAsFixed(2)}",
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Discount", style: TextStyle(fontSize: 14)),
                        Text(
                          "-\$${booking.discount.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Taxes & Fees",
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          "\$${booking.taxes.toStringAsFixed(2)}",
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Divider(height: 1),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Total Paid",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "\$${booking.totalPrice.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Action Buttons
          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                if (isUpcoming && booking.status != 'cancelled')
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _showCancelDialog(context, booking.id),
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey[200],
                        ),
                        child: const Center(
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                if (isUpcoming && booking.status != 'cancelled')
                  const SizedBox(width: 10),
                if (!isUpcoming || booking.status == 'cancelled')
                  Expanded(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey[200],
                      ),
                      child: Center(
                        child: Text(
                          isUpcoming ? "Cancelled" : "Write a Review",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                if ((!isUpcoming || booking.status == 'cancelled') &&
                    isUpcoming)
                  const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      // Handle view details or book again
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            isUpcoming && booking.status != 'cancelled'
                                ? 'View details feature coming soon!'
                                : 'Book again feature coming soon!',
                          ),
                        ),
                      );
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blue,
                      ),
                      child: Center(
                        child: Text(
                          isUpcoming && booking.status != 'cancelled'
                              ? "View Details"
                              : "Book Again",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
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

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      case 'completed':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  void _showCancelDialog(BuildContext context, String bookingId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Cancel Booking"),
          content: const Text(
            "Are you sure you want to cancel this booking? A cancellation fee may apply.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () async {
                try {
                  // Show loading
                  Navigator.of(context).pop();
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return const Center(child: CircularProgressIndicator());
                    },
                  );

                  await FirebaseFirestore.instance
                      .collection('bookings')
                      .doc(bookingId)
                      .update({'status': 'cancelled'});

                  // Hide loading
                  Navigator.of(context).pop();

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Booking cancelled successfully"),
                      backgroundColor: Colors.green,
                    ),
                  );
                } catch (e) {
                  // Hide loading
                  Navigator.of(context).pop();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Failed to cancel booking: $e"),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  String _formatGuestInfo(BookingItem booking) {
    List<String> guestParts = [];
    if (booking.adults > 0) {
      guestParts.add("${booking.adults} Adult${booking.adults > 1 ? 's' : ''}");
    }
    if (booking.children > 0) {
      guestParts.add(
        "${booking.children} Child${booking.children > 1 ? 'ren' : ''}",
      );
    }
    return guestParts.join(", ");
  }
}

class BookingItem {
  final String id;
  final String userId;
  final String hotelId;
  final String hotelName;
  final String hotelLocation;
  final String hotelImage;
  final double hotelRating;
  final int hotelReviewCount;
  final String checkInDate;
  final String checkOutDate;
  final String checkInTime;
  final String checkOutTime;
  final int nights;
  final int adults;
  final int children;
  final double pricePerNight;
  final double discount;
  final double taxes;
  final double totalPrice;
  final String status;
  final DateTime createdAt;

  BookingItem({
    required this.id,
    required this.userId,
    required this.hotelId,
    required this.hotelName,
    required this.hotelLocation,
    required this.hotelImage,
    required this.hotelRating,
    required this.hotelReviewCount,
    required this.checkInDate,
    required this.checkOutDate,
    required this.checkInTime,
    required this.checkOutTime,
    required this.nights,
    required this.adults,
    required this.children,
    required this.pricePerNight,
    required this.discount,
    required this.taxes,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
  });

  factory BookingItem.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    print('Converting document to BookingItem: ${doc.id}');
    print('Document data: $data');

    return BookingItem(
      id: doc.id,
      userId: data['userId'] ?? '',
      hotelId: data['hotelId'] ?? '',
      hotelName: data['hotelName'] ?? 'Unknown Hotel',
      hotelLocation: data['hotelLocation'] ?? 'Unknown Location',
      hotelImage: data['hotelImage'] ?? 'assets/images/room1.png',
      hotelRating: (data['hotelRating'] ?? 0).toDouble(),
      hotelReviewCount: data['hotelReviewCount'] ?? 0,
      checkInDate: data['checkInDate'] ?? '',
      checkOutDate: data['checkOutDate'] ?? '',
      checkInTime: data['checkInTime'] ?? '2:00 PM',
      checkOutTime: data['checkOutTime'] ?? '11:00 AM',
      nights: data['nights'] ?? 1,
      adults: data['adults'] ?? 1,
      children: data['children'] ?? 0,
      pricePerNight: (data['pricePerNight'] ?? 0).toDouble(),
      discount: (data['discount'] ?? 0).toDouble(),
      taxes: (data['taxes'] ?? 0).toDouble(),
      totalPrice: (data['totalPrice'] ?? 0).toDouble(),
      status: data['status'] ?? 'pending',
      createdAt:
          data['createdAt'] != null
              ? (data['createdAt'] as Timestamp).toDate()
              : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'hotelId': hotelId,
      'hotelName': hotelName,
      'hotelLocation': hotelLocation,
      'hotelImage': hotelImage,
      'hotelRating': hotelRating,
      'hotelReviewCount': hotelReviewCount,
      'checkInDate': checkInDate,
      'checkOutDate': checkOutDate,
      'checkInTime': checkInTime,
      'checkOutTime': checkOutTime,
      'nights': nights,
      'adults': adults,
      'children': children,
      'pricePerNight': pricePerNight,
      'discount': discount,
      'taxes': taxes,
      'totalPrice': totalPrice,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
