import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hotelbooking/features/screen/booking/booking_service.dart';
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
        onLeadingTap:
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            ),
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

        final allBookings =
            snapshot.data!.docs.map((doc) {
              print('Document ID: ${doc.id}');
              print('Document data: ${doc.data()}');
              return BookingItem.fromFirestore(doc);
            }).toList();

        final filteredBookings =
            allBookings.where((booking) {
              if (isUpcoming) {
                return booking.status == 'confirmed' ||
                    booking.status == 'pending';
              } else {
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

class BookingCard extends StatefulWidget {
  final BookingItem booking;
  final bool isUpcoming;

  const BookingCard({
    super.key,
    required this.booking,
    required this.isUpcoming,
  });

  @override
  State<BookingCard> createState() => _BookingCardState();
}

class _BookingCardState extends State<BookingCard> {
  bool _isDeleting = false;

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
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: _getStatusColor(widget.booking.status).withOpacity(0.1),
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
                      "Booking ID: ${widget.booking.id}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${widget.booking.checkInDate} - ${widget.booking.checkOutDate}",
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
                    color: _getStatusColor(widget.booking.status),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    widget.booking.status.toUpperCase(),
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

          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child:
                      widget.booking.hotelImage.startsWith('http')
                          ? Image.network(
                            widget.booking.hotelImage,
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
                            widget.booking.hotelImage,
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
                        widget.booking.hotelName,
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
                              widget.booking.hotelLocation,
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
                            widget.booking.hotelRating.floor(),
                            (index) => const Icon(
                              Icons.star,
                              size: 16,
                              color: Colors.amber,
                            ),
                          ),
                          if (widget.booking.hotelRating -
                                  widget.booking.hotelRating.floor() >=
                              0.5)
                            const Icon(
                              Icons.star_half,
                              size: 16,
                              color: Colors.amber,
                            ),
                          const SizedBox(width: 4),
                          Text(
                            "(${widget.booking.hotelReviewCount} reviews)",
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

          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
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
                            widget.booking.checkInDate,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            widget.booking.checkInTime,
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
                        "${widget.booking.nights} Night${widget.booking.nights > 1 ? 's' : ''}",
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
                            widget.booking.checkOutDate,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            widget.booking.checkOutTime,
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
                      _formatGuestInfo(widget.booking),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "\$${widget.booking.pricePerNight.toStringAsFixed(2)} × ${widget.booking.nights} night${widget.booking.nights > 1 ? 's' : ''}",
                          style: const TextStyle(fontSize: 14),
                        ),
                        Text(
                          "\$${(widget.booking.pricePerNight * widget.booking.nights).toStringAsFixed(2)}",
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
                          "-\$${widget.booking.discount.toStringAsFixed(2)}",
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
                          "\$${widget.booking.taxes.toStringAsFixed(2)}",
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
                          "\$${widget.booking.totalPrice.toStringAsFixed(2)}",
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

          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                if (widget.isUpcoming && widget.booking.status != 'cancelled')
                  Expanded(
                    child: GestureDetector(
                      onTap: _isDeleting ? null : () => _showDeleteDialog(),
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color:
                              _isDeleting ? Colors.grey[300] : Colors.red[50],
                          border: Border.all(
                            color: _isDeleting ? Colors.grey : Colors.red,
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child:
                              _isDeleting
                                  ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.grey,
                                      ),
                                    ),
                                  )
                                  : const Text(
                                    "Cancle Booking",
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                        ),
                      ),
                    ),
                  ),
                if (widget.isUpcoming && widget.booking.status != 'cancelled')
                  const SizedBox(width: 10),
                if (!widget.isUpcoming || widget.booking.status == 'cancelled')
                  Expanded(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey[200],
                      ),
                      child: Center(
                        child: Text(
                          widget.isUpcoming ? "Cancelled" : "Write a Review",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                if ((!widget.isUpcoming ||
                        widget.booking.status == 'cancelled') &&
                    widget.isUpcoming)
                  const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              widget.isUpcoming &&
                                      widget.booking.status != 'cancelled'
                                  ? 'View details feature coming soon!'
                                  : 'Book again feature coming soon!',
                            ),
                          ),
                        );
                      }
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blue,
                      ),
                      child: Center(
                        child: Text(
                          widget.isUpcoming &&
                                  widget.booking.status != 'cancelled'
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

  void _showDeleteDialog() {
    if (!mounted) return;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: Colors.red[600],
                size: 28,
              ),
              const SizedBox(width: 10),
              const Text(
                "Delete Booking",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: const Text(
            "Are you sure you want to delete this booking permanently? This action cannot be undone and all booking data will be removed from the database.",
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (Navigator.canPop(dialogContext)) {
                  Navigator.of(dialogContext).pop();
                }
              },
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (Navigator.canPop(dialogContext)) {
                  Navigator.of(dialogContext).pop();
                }

                await _deleteBooking();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "Delete",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteBooking() async {
    if (!mounted) return;

    setState(() {
      _isDeleting = true;
    });

    try {
      bool success = await BookingService.deleteBooking(widget.booking.id);

      if (!mounted) return;

      setState(() {
        _isDeleting = false;
      });

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 10),
                Text(
                  "Booking deleted successfully",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.error, color: Colors.white),
                SizedBox(width: 10),
                Text(
                  "Failed to delete booking",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isDeleting = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error, color: Colors.white),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  "Error deleting booking: $e",
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
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
