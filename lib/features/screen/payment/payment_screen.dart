import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hotelbooking/features/screen/home/home_screen.dart';
import 'package:hotelbooking/features/screen/booking/booking_screen.dart';
import 'package:hotelbooking/features/widgets/commonappbar/custom_app_bar.dart';
import 'package:hotelbooking/features/widgets/commonbutton/common_buttom.dart';
import 'package:hotelbooking/features/widgets/commonbottomsheet/Common_BottomSheet.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class BookingService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static String _generateBookingId() {
    final random = Random();
    int bookingNumber = 10000 + random.nextInt(90000);
    return bookingNumber.toString();
  }

  static Future<bool> _isBookingIdUnique(String bookingId) async {
    try {
      final querySnapshot =
          await _firestore
              .collection('bookings')
              .where('bookingId', isEqualTo: bookingId)
              .limit(1)
              .get();
      return querySnapshot.docs.isEmpty;
    } catch (e) {
      print('Error checking booking ID uniqueness: $e');
      return false;
    }
  }

  static Future<String> _generateUniqueBookingId() async {
    String bookingId;
    bool isUnique = false;
    int attempts = 0;
    const maxAttempts = 10;

    do {
      bookingId = _generateBookingId();
      isUnique = await _isBookingIdUnique(bookingId);
      attempts++;

      if (attempts >= maxAttempts) {
        final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
        bookingId = timestamp.substring(timestamp.length - 5);
        break;
      }
    } while (!isUnique);

    return bookingId;
  }

  static Future<String?> createBooking({
    required String hotelId,
    required String hotelName,
    required String hotelLocation,
    required String hotelImage,
    required String checkInDate,
    required String checkOutDate,
    required String checkInTime,
    required String checkOutTime,
    required int nights,
    required int adults,
    required int children,
    required int infants,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final customBookingId = await _generateUniqueBookingId();

      final bookingData = {
        'bookingId': customBookingId,
        'userId': user.uid,
        'hotelId': hotelId,
        'hotelName': hotelName,
        'hotelLocation': hotelLocation,
        'hotelImage': hotelImage,
        'checkInDate': checkInDate,
        'checkOutDate': checkOutDate,
        'checkInTime': checkInTime,
        'checkOutTime': checkOutTime,
        'nights': nights,
        'adults': adults,
        'children': children,
        'infants': infants,
        'status': 'confirmed',
        'createdAt': FieldValue.serverTimestamp(),
      };

      await _firestore
          .collection('bookings')
          .doc(customBookingId)
          .set(bookingData);

      print('Booking created with ID: $customBookingId');
      return customBookingId;
    } catch (e) {
      print('Error creating booking: $e');
      return null;
    }
  }

  static Future<bool> cancelBooking(String bookingId) async {
    try {
      await _firestore.collection('bookings').doc(bookingId).update({
        'status': 'cancelled',
        'cancelledAt': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      print('Error cancelling booking: $e');
      return false;
    }
  }

  static Future<bool> deleteBooking(String bookingId) async {
    try {
      await _firestore.collection('bookings').doc(bookingId).delete();
      print('Booking deleted successfully: $bookingId');
      return true;
    } catch (e) {
      print('Error deleting booking: $e');
      return false;
    }
  }
}

class PaymentScreen extends StatefulWidget {
  final Map<String, dynamic>? hotelData;
  final DateTime? selectedDate;
  final DateTime? checkOutDate;
  final int? numberOfNights;
  final int? adultCount;
  final int? childrenCount;
  final int? infantsCount;

  const PaymentScreen({
    super.key,
    this.hotelData,
    this.selectedDate,
    this.checkOutDate,
    this.numberOfNights,
    this.adultCount,
    this.childrenCount,
    this.infantsCount,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int _selectedPaymentOption = 0;
  bool _isProcessingPayment = false;

  final TextEditingController cardHolderController = TextEditingController();
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();
  final TextEditingController expiryDateController = TextEditingController();

  int pricePerNight = 120;
  int nights = 1;
  int subtotal = 120;
  int discount = 0;
  int taxes = 10;
  int grandTotal = 130;
  String checkInDate = "";
  String checkOutDate = "";
  String guestInfo = "";

  @override
  void initState() {
    super.initState();
    _initializeBookingData();
  }

  @override
  void dispose() {
    cardHolderController.dispose();
    cardNumberController.dispose();
    cvvController.dispose();
    expiryDateController.dispose();
    super.dispose();
  }

  void _initializeBookingData() {
    if (widget.hotelData != null) {
      pricePerNight = widget.hotelData!['price'] ?? 120;
    }

    if (widget.numberOfNights != null) {
      nights = widget.numberOfNights!;
    }

    subtotal = pricePerNight * nights;
    discount = (subtotal * 0.1).round();
    taxes = (subtotal * 0.05).round();
    grandTotal = subtotal - discount + taxes;

    if (widget.selectedDate != null) {
      checkInDate = DateFormat('MMM dd, yyyy').format(widget.selectedDate!);

      if (widget.checkOutDate != null) {
        checkOutDate = DateFormat('MMM dd, yyyy').format(widget.checkOutDate!);
      } else {
        final checkOut = widget.selectedDate!.add(Duration(days: nights));
        checkOutDate = DateFormat('MMM dd, yyyy').format(checkOut);
      }
    } else {
      final now = DateTime.now();
      checkInDate = DateFormat('MMM dd, yyyy').format(now);
      checkOutDate = DateFormat(
        'MMM dd, yyyy',
      ).format(now.add(Duration(days: nights)));
    }

    final adults = widget.adultCount ?? 1;
    final children = widget.childrenCount ?? 0;
    final infants = widget.infantsCount ?? 0;

    List<String> guestParts = [];
    if (adults > 0) guestParts.add("$adults adult${adults > 1 ? 's' : ''}");
    if (children > 0)
      guestParts.add("$children child${children > 1 ? 'ren' : ''}");
    if (infants > 0) guestParts.add("$infants infant${infants > 1 ? 's' : ''}");

    guestInfo = guestParts.isNotEmpty ? guestParts.join(" | ") : "1 adult";
  }

  Future<String?> _createFirebaseBooking() async {
    try {
      return await BookingService.createBooking(
        hotelId:
            widget.hotelData?['id'] ??
            'hotel_${DateTime.now().millisecondsSinceEpoch}',
        hotelName: widget.hotelData?['name'] ?? "Hotel Name",
        hotelLocation: widget.hotelData?['location'] ?? "Location",
        hotelImage: widget.hotelData?['image'] ?? "assets/images/room1.png",
        checkInDate: checkInDate,
        checkOutDate: checkOutDate,
        checkInTime: "02:00 PM",
        checkOutTime: "12:00 PM",
        nights: nights,
        adults: widget.adultCount ?? 1,
        children: widget.childrenCount ?? 0,
        infants: widget.infantsCount ?? 0,
      );
    } catch (e) {
      print('Error creating Firebase booking: $e');
      return null;
    }
  }

  Future<void> _processPayment() async {
    if (!mounted) return;

    setState(() => _isProcessingPayment = true);

    try {
      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) return;

      final bookingId = await _createFirebaseBooking();
      if (!mounted) return;

      setState(() => _isProcessingPayment = false);

      if (bookingId != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _showPaymentSuccessBottomSheet(bookingId);
        });
      } else {
        _showSnackBar(
          'Failed to create booking. Please try again.',
          Colors.red,
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isProcessingPayment = false);
      _showSnackBar('Payment failed: ${e.toString()}', Colors.red);
    }
  }

  void _showSnackBar(String message, Color backgroundColor) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: backgroundColor),
        );
      }
    });
  }

  void _showPaymentSuccessBottomSheet(String bookingId) {
    showCommonBottomSheet(
      context: context,
      child: StatefulBuilder(
        builder: (context, setState) {
          return Container(
            height: 570,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Image.asset("assets/icon/submit.jpg", height: 120, width: 120),
                const SizedBox(height: 16),
                const Text(
                  "Payment Received",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                const Text(
                  "Successfully",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Congratulation",
                      style: TextStyle(fontSize: 17),
                    ),
                    Image.asset("assets/icon/party.png", height: 30, width: 30),
                  ],
                ),
                const Text(
                  "Your booking has been confirmed",
                  style: TextStyle(fontSize: 17),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Booking ID: $bookingId",
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1190F8),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.hotelData?['name'] ?? 'Hotel Name',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "$checkInDate - $checkOutDate",
                        style: const TextStyle(fontSize: 14),
                      ),
                      Text(guestInfo, style: const TextStyle(fontSize: 14)),
                      Text(
                        "$nights night${nights > 1 ? 's' : ''}",
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.currency_rupee,
                            color: Color(0xFF1190F8),
                            size: 18,
                          ),
                          Text(
                            "Total Paid: ${grandTotal.toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1190F8),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        text: "View Booking",
                        textStyle: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          if (mounted) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const BookingScreen(),
                              ),
                              (route) => false,
                            );
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CustomButton(
                        text: "Back To Home",
                        textStyle: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          if (mounted) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomeScreen(),
                              ),
                              (route) => false,
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        mainTitle: 'Confirm & Pay',
        leadingIcon: Icons.arrow_back_ios,
        onLeadingTap: () => Navigator.maybePop(context),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPropertyCard(),
            const SectionHeader(title: "Your Booking Details"),
            EditableInfoRow(
              title: "Dates",
              value: "$checkInDate - $checkOutDate",
              onEditPressed: () => _editDates(),
            ),

            EditableInfoRow(
              title: "Guests",
              value: guestInfo,
              onEditPressed: () => _editGuests(),
            ),
            EditableInfoRow(
              title: "Duration",
              value: "$nights night${nights > 1 ? 's' : ''}",
              onEditPressed: () => _editDates(),
            ),
            const Divider(color: Colors.grey, thickness: 1),
            const SectionHeader(title: "Pay with"),
            _buildPaymentMethods(),
            const Divider(color: Colors.grey, thickness: 1),
            const SectionHeader(title: "Price Details"),
            PriceDetailRow(
              label: "₹$pricePerNight x $nights night${nights > 1 ? 's' : ''}",
              value: "₹${subtotal.toStringAsFixed(2)}",
            ),
            PriceDetailRow(
              label: "Discount (10%)",
              value: "-₹${discount.toStringAsFixed(2)}",
              isDiscount: true,
            ),
            PriceDetailRow(
              label: "Occupancy taxes and fees (5%)",
              value: "₹${taxes.toStringAsFixed(2)}",
            ),
            const Divider(color: Colors.grey, thickness: 1),
            PriceDetailRow(
              label: "Grand Total",
              value: "₹${grandTotal.toStringAsFixed(2)}",
              isTotal: true,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child:
                  _isProcessingPayment
                      ? Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey,
                        ),
                        child: const Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Text(
                                "Processing Payment...",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      : Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: CustomButton(
                          text: "Pay Now - ₹${grandTotal.toStringAsFixed(2)}",
                          width: double.infinity,
                          height: 50,
                          onPressed: _processPayment,
                        ),
                      ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPropertyCard() {
    final hotelName = widget.hotelData?['name'] ?? "Hotel Name";
    final hotelImage = widget.hotelData?['image'] ?? "assets/images/room1.png";
    final hotelLocation = widget.hotelData?['location'] ?? "Location";

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      hotelImage,
                      height: 130,
                      width: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 15.0, right: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hotelName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          color: Colors.black,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            hotelLocation,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      guestInfo,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "$nights night${nights > 1 ? 's' : ''}",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF1190F8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethods() {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // const Text(
              //   "Payment method",
              //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              // ),
              Text(
                "Cash on Payment",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _editDates() {
    if (mounted) Navigator.maybePop(context);
  }

  void _editGuests() {
    if (mounted) Navigator.maybePop(context);
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, top: 10),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class EditableInfoRow extends StatelessWidget {
  final String title;
  final String value;
  final VoidCallback onEditPressed;

  const EditableInfoRow({
    super.key,
    required this.title,
    required this.value,
    required this.onEditPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(fontSize: 15, color: Colors.grey),
                ),
              ],
            ),
          ),
          Container(
            height: 35,
            width: 35,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                width: 2,
                color: const Color.fromARGB(255, 17, 144, 248),
              ),
            ),
            child: InkWell(
              onTap: onEditPressed,
              borderRadius: BorderRadius.circular(10),
              child: const Center(
                child: Icon(
                  Icons.edit,
                  size: 20,
                  color: Color.fromARGB(255, 17, 144, 248),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PaymentOptionRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final int value;
  final int groupValue;
  final ValueChanged<int?> onChanged;

  const PaymentOptionRow({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15.0, top: 10.0, right: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(fontSize: 17, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Radio<int>(
                value: value,
                groupValue: groupValue,
                onChanged: onChanged,
                activeColor: const Color.fromARGB(255, 17, 144, 248),
              ),
            ],
          ),
        ),
        const Divider(color: Colors.grey, thickness: 1),
      ],
    );
  }
}

class PriceDetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;
  final bool isDiscount;

  const PriceDetailRow({
    super.key,
    required this.label,
    required this.value,
    this.isTotal = false,
    this.isDiscount = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: isTotal ? 20 : 18,
                fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          Row(
            children: [
              if (!value.startsWith('-'))
                const Icon(
                  Icons.currency_rupee,
                  size: 16,
                  color: Colors.black87,
                ),
              Text(
                value.startsWith('-') ? value : value.substring(1),
                style: TextStyle(
                  fontSize: isTotal ? 20 : 18,
                  fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                  color: isDiscount ? Colors.green : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:hotelbooking/features/screen/home/home_screen.dart';
// import 'package:hotelbooking/features/screen/booking/booking_screen.dart';
// import 'package:hotelbooking/features/widgets/commonappbar/custom_app_bar.dart';
// import 'package:hotelbooking/features/widgets/commonbutton/common_buttom.dart';
// import 'package:hotelbooking/features/widgets/commonbottomsheet/Common_BottomSheet.dart';
// import 'package:intl/intl.dart';
// import 'dart:math';

// class BookingService {
//   static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   static final FirebaseAuth _auth = FirebaseAuth.instance;

//   static String _generateBookingId() {
//     final random = Random();
//     int bookingNumber = 10000 + random.nextInt(90000);
//     return bookingNumber.toString();
//   }

//   static Future<bool> _isBookingIdUnique(String bookingId) async {
//     try {
//       final querySnapshot =
//           await _firestore
//               .collection('bookings')
//               .where('bookingId', isEqualTo: bookingId)
//               .limit(1)
//               .get();
//       return querySnapshot.docs.isEmpty;
//     } catch (e) {
//       print('Error checking booking ID uniqueness: $e');
//       return false;
//     }
//   }

//   static Future<String> _generateUniqueBookingId() async {
//     String bookingId;
//     bool isUnique = false;
//     int attempts = 0;
//     const maxAttempts = 10;

//     do {
//       bookingId = _generateBookingId();
//       isUnique = await _isBookingIdUnique(bookingId);
//       attempts++;

//       if (attempts >= maxAttempts) {
//         final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
//         bookingId = timestamp.substring(timestamp.length - 5);
//         break;
//       }
//     } while (!isUnique);

//     return bookingId;
//   }

//   static Future<String?> createBooking({
//     required String hotelId,
//     required String hotelName,
//     required String hotelLocation,
//     required String hotelImage,
//     required String checkInDate,
//     required String checkOutDate,
//     required String checkInTime,
//     required String checkOutTime,
//     required int nights,
//     required int adults,
//     required int children,
//     required int infants,
//   }) async {
//     try {
//       final user = _auth.currentUser;
//       if (user == null) throw Exception('User not authenticated');

//       final customBookingId = await _generateUniqueBookingId();

//       final bookingData = {
//         'bookingId': customBookingId,
//         'userId': user.uid,
//         'hotelId': hotelId,
//         'hotelName': hotelName,
//         'hotelLocation': hotelLocation,
//         'hotelImage': hotelImage,
//         'checkInDate': checkInDate,
//         'checkOutDate': checkOutDate,
//         'checkInTime': checkInTime,
//         'checkOutTime': checkOutTime,
//         'nights': nights,
//         'adults': adults,
//         'children': children,
//         'infants': infants,
//         'status': 'confirmed',
//         'createdAt': FieldValue.serverTimestamp(),
//       };

//       await _firestore
//           .collection('bookings')
//           .doc(customBookingId)
//           .set(bookingData);
//       print('Booking created with ID: $customBookingId');
//       return customBookingId;
//     } catch (e) {
//       print('Error creating booking: $e');
//       return null;
//     }
//   }

//   static Future<bool> cancelBooking(String bookingId) async {
//     try {
//       await _firestore.collection('bookings').doc(bookingId).update({
//         'status': 'cancelled',
//         'cancelledAt': FieldValue.serverTimestamp(),
//       });
//       return true;
//     } catch (e) {
//       print('Error cancelling booking: $e');
//       return false;
//     }
//   }

//   static Future<bool> deleteBooking(String bookingId) async {
//     try {
//       await _firestore.collection('bookings').doc(bookingId).delete();
//       print('Booking deleted successfully: $bookingId');
//       return true;
//     } catch (e) {
//       print('Error deleting booking: $e');
//       return false;
//     }
//   }
// }

// class PaymentScreen extends StatefulWidget {
//   final Map<String, dynamic>? hotelData;
//   final DateTime? selectedDate;
//   final DateTime? checkOutDate;
//   final int? numberOfNights;
//   final int? adultCount;
//   final int? childrenCount;
//   final int? infantsCount;

//   const PaymentScreen({
//     super.key,
//     this.hotelData,
//     this.selectedDate,
//     this.checkOutDate,
//     this.numberOfNights,
//     this.adultCount,
//     this.childrenCount,
//     this.infantsCount,
//   });

//   @override
//   State<PaymentScreen> createState() => _PaymentScreenState();
// }

// class _PaymentScreenState extends State<PaymentScreen> {
//   int _selectedPaymentOption = 0;
//   bool _isProcessingPayment = false;

//   final TextEditingController cardHolderController = TextEditingController();
//   final TextEditingController cardNumberController = TextEditingController();
//   final TextEditingController cvvController = TextEditingController();
//   final TextEditingController expiryDateController = TextEditingController();

//   int pricePerNight = 120;
//   int nights = 1;
//   int subtotal = 120;
//   int discount = 0;
//   int taxes = 10;
//   int grandTotal = 130;

//   // Date variables
//   DateTime? checkInDateTime;
//   DateTime? checkOutDateTime;
//   String checkInDate = "";
//   String checkOutDate = "";
//   String guestInfo = "";

//   @override
//   void initState() {
//     super.initState();
//     _initializeBookingData();
//   }

//   @override
//   void dispose() {
//     cardHolderController.dispose();
//     cardNumberController.dispose();
//     cvvController.dispose();
//     expiryDateController.dispose();
//     super.dispose();
//   }

//   // Updated initialization method - no automatic check-out date calculation
//   void _initializeBookingData() {
//     if (widget.hotelData != null) {
//       pricePerNight = widget.hotelData!['price'] ?? 120;
//     }

//     // Set check-in date
//     if (widget.selectedDate != null) {
//       checkInDateTime = widget.selectedDate!;
//       checkInDate = DateFormat('MMM dd, yyyy').format(widget.selectedDate!);
//     } else {
//       checkInDateTime = DateTime.now();
//       checkInDate = DateFormat('MMM dd, yyyy').format(DateTime.now());
//     }

//     // Initialize check-out date as unselected - NO automatic calculation
//     checkOutDate = "Select Check-out Date";
//     nights = 1; // Default to 1 night until user selects check-out date

//     // Calculate pricing with default values
//     subtotal = pricePerNight * nights;
//     discount = (subtotal * 0.1).round();
//     taxes = (subtotal * 0.05).round();
//     grandTotal = subtotal - discount + taxes;

//     // Set guest info
//     final adults = widget.adultCount ?? 1;
//     final children = widget.childrenCount ?? 0;
//     final infants = widget.infantsCount ?? 0;

//     List<String> guestParts = [];
//     if (adults > 0) guestParts.add("$adults adult${adults > 1 ? 's' : ''}");
//     if (children > 0)
//       guestParts.add("$children child${children > 1 ? 'ren' : ''}");
//     if (infants > 0) guestParts.add("$infants infant${infants > 1 ? 's' : ''}");

//     guestInfo = guestParts.isNotEmpty ? guestParts.join(" | ") : "1 adult";
//   }

//   // Enhanced date validation method
//   bool _validateDates() {
//     if (checkInDateTime == null) {
//       _showSnackBar('Please select a check-in date', Colors.red);
//       return false;
//     }

//     if (checkOutDateTime == null) {
//       _showSnackBar('Please select a check-out date', Colors.red);
//       return false;
//     }

//     if (checkOutDateTime!.isBefore(checkInDateTime!) ||
//         checkOutDateTime!.isAtSameMomentAs(checkInDateTime!)) {
//       _showSnackBar('Check-out date must be after check-in date', Colors.red);
//       return false;
//     }

//     return true;
//   }

//   // Updated check-out date selection method
//   Future<void> _selectCheckOutDate() async {
//     if (checkInDateTime == null) {
//       _showSnackBar('Please select check-in date first', Colors.red);
//       return;
//     }

//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: checkInDateTime!.add(const Duration(days: 1)),
//       firstDate: checkInDateTime!.add(const Duration(days: 1)),
//       lastDate: DateTime.now().add(const Duration(days: 365)),
//       builder: (context, child) {
//         return Theme(
//           data: Theme.of(context).copyWith(
//             colorScheme: const ColorScheme.light(
//               primary: Color(0xFF1190F8),
//               onPrimary: Colors.white,
//               surface: Colors.white,
//               onSurface: Colors.black,
//             ),
//           ),
//           child: child!,
//         );
//       },
//     );

//     if (picked != null) {
//       setState(() {
//         checkOutDateTime = picked;
//         checkOutDate = DateFormat('MMM dd, yyyy').format(picked);
//         nights = checkOutDateTime!.difference(checkInDateTime!).inDays;
//         if (nights <= 0) nights = 1;

//         // Recalculate pricing
//         subtotal = pricePerNight * nights;
//         discount = (subtotal * 0.1).round();
//         taxes = (subtotal * 0.05).round();
//         grandTotal = subtotal - discount + taxes;
//       });
//     }
//   }

//   Future<String?> _createFirebaseBooking() async {
//     try {
//       return await BookingService.createBooking(
//         hotelId:
//             widget.hotelData?['id'] ??
//             'hotel_${DateTime.now().millisecondsSinceEpoch}',
//         hotelName: widget.hotelData?['name'] ?? "Hotel Name",
//         hotelLocation: widget.hotelData?['location'] ?? "Location",
//         hotelImage: widget.hotelData?['image'] ?? "assets/images/room1.png",
//         checkInDate: checkInDate,
//         checkOutDate: checkOutDate,
//         checkInTime: "02:00 PM",
//         checkOutTime: "12:00 PM",
//         nights: nights,
//         adults: widget.adultCount ?? 1,
//         children: widget.childrenCount ?? 0,
//         infants: widget.infantsCount ?? 0,
//       );
//     } catch (e) {
//       print('Error creating Firebase booking: $e');
//       return null;
//     }
//   }

//   // Updated process payment method with date validation
//   Future<void> _processPayment() async {
//     if (!mounted) return;

//     // Validate dates before processing payment
//     if (!_validateDates()) {
//       return;
//     }

//     setState(() => _isProcessingPayment = true);

//     try {
//       await Future.delayed(const Duration(seconds: 2));
//       if (!mounted) return;

//       final bookingId = await _createFirebaseBooking();
//       if (!mounted) return;

//       setState(() => _isProcessingPayment = false);

//       if (bookingId != null) {
//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           if (mounted) _showPaymentSuccessBottomSheet(bookingId);
//         });
//       } else {
//         _showSnackBar(
//           'Failed to create booking. Please try again.',
//           Colors.red,
//         );
//       }
//     } catch (e) {
//       if (!mounted) return;
//       setState(() => _isProcessingPayment = false);
//       _showSnackBar('Payment failed: ${e.toString()}', Colors.red);
//     }
//   }

//   void _showSnackBar(String message, Color backgroundColor) {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(message),
//             backgroundColor: backgroundColor,
//             duration: const Duration(seconds: 3),
//           ),
//         );
//       }
//     });
//   }

//   void _showPaymentSuccessBottomSheet(String bookingId) {
//     showCommonBottomSheet(
//       context: context,
//       child: StatefulBuilder(
//         builder: (context, setState) {
//           return Container(
//             height: 570,
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               children: [
//                 Image.asset("assets/icon/submit.jpg", height: 120, width: 120),
//                 const SizedBox(height: 16),
//                 const Text(
//                   "Payment Received",
//                   style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
//                 ),
//                 const Text(
//                   "Successfully",
//                   style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 12),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Text(
//                       "Congratulation",
//                       style: TextStyle(fontSize: 17),
//                     ),
//                     Image.asset("assets/icon/party.png", height: 30, width: 30),
//                   ],
//                 ),
//                 const Text(
//                   "Your booking has been confirmed",
//                   style: TextStyle(fontSize: 17),
//                 ),
//                 const SizedBox(height: 16),
//                 Container(
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: Colors.grey[100],
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Column(
//                     children: [
//                       Text(
//                         "Booking ID: $bookingId",
//                         style: const TextStyle(
//                           fontSize: 15,
//                           fontWeight: FontWeight.bold,
//                           color: Color(0xFF1190F8),
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         widget.hotelData?['name'] ?? 'Hotel Name',
//                         style: const TextStyle(
//                           fontSize: 15,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         "$checkInDate - $checkOutDate",
//                         style: const TextStyle(fontSize: 14),
//                       ),
//                       Text(guestInfo, style: const TextStyle(fontSize: 14)),
//                       Text(
//                         "$nights night${nights > 1 ? 's' : ''}",
//                         style: const TextStyle(fontSize: 14),
//                       ),
//                       const SizedBox(height: 8),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           const Icon(
//                             Icons.currency_rupee,
//                             color: Color(0xFF1190F8),
//                             size: 18,
//                           ),
//                           Text(
//                             "Total Paid: ${grandTotal.toStringAsFixed(2)}",
//                             style: const TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                               color: Color(0xFF1190F8),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: CustomButton(
//                         text: "View Booking",
//                         textStyle: const TextStyle(
//                           fontSize: 12,
//                           color: Colors.white,
//                         ),
//                         onPressed: () {
//                           if (mounted) {
//                             Navigator.pushAndRemoveUntil(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => const BookingScreen(),
//                               ),
//                               (route) => false,
//                             );
//                           }
//                         },
//                       ),
//                     ),
//                     const SizedBox(width: 10),
//                     Expanded(
//                       child: CustomButton(
//                         text: "Back To Home",
//                         textStyle: const TextStyle(
//                           fontSize: 12,
//                           color: Colors.white,
//                         ),
//                         onPressed: () {
//                           if (mounted) {
//                             Navigator.pushAndRemoveUntil(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => const HomeScreen(),
//                               ),
//                               (route) => false,
//                             );
//                           }
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   // Enhanced check-out date display widget
//   Widget _buildCheckOutDateField() {
//     return GestureDetector(
//       onTap: _selectCheckOutDate,
//       child: Container(
//         padding: const EdgeInsets.only(left: 15.0, top: 10.0, right: 15.0),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     "Check-out Date",
//                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                   ),
//                   Text(
//                     checkOutDate,
//                     style: TextStyle(
//                       fontSize: 18,
//                       color:
//                           checkOutDateTime == null ? Colors.red : Colors.grey,
//                     ),
//                   ),
//                   if (checkOutDateTime == null)
//                     const Text(
//                       "Please select check-out date",
//                       style: TextStyle(fontSize: 14, color: Colors.red),
//                     ),
//                 ],
//               ),
//             ),
//             Container(
//               height: 50,
//               width: 50,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10),
//                 border: Border.all(
//                   width: 2,
//                   color: const Color.fromARGB(255, 17, 144, 248),
//                 ),
//               ),
//               child: const Icon(
//                 Icons.calendar_today,
//                 size: 25,
//                 color: Color.fromARGB(255, 17, 144, 248),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CommonAppBar(
//         mainTitle: 'Confirm & Pay',
//         leadingIcon: Icons.arrow_back_ios,
//         onLeadingTap: () => Navigator.maybePop(context),
//         elevation: 2,
//         height: 60,
//         leadingIconColor: Colors.black,
//         mainTitleStyle: const TextStyle(
//           fontSize: 24,
//           fontWeight: FontWeight.bold,
//           color: Colors.black,
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildPropertyCard(),
//             const SectionHeader(title: "Your Booking Details"),
//             EditableInfoRow(
//               title: "Check-in Date",
//               value: checkInDate,
//               onEditPressed: () => _editDates(),
//             ),
//             const SizedBox(height: 15),
//             // Use the enhanced check-out date field
//             _buildCheckOutDateField(),
//             const SizedBox(height: 15),
//             EditableInfoRow(
//               title: "Guests",
//               value: guestInfo,
//               onEditPressed: () => _editGuests(),
//             ),
//             EditableInfoRow(
//               title: "Duration",
//               value: "$nights night${nights > 1 ? 's' : ''}",
//               onEditPressed: () => _selectCheckOutDate(),
//             ),
//             const Divider(color: Colors.grey, thickness: 1),
//             const SectionHeader(title: "Choose how to pay"),
//             PaymentOptionRow(
//               title: "Pay in full",
//               subtitle: "Pay the total now and you're all set",
//               value: 0,
//               groupValue: _selectedPaymentOption,
//               onChanged: (value) {
//                 if (mounted) setState(() => _selectedPaymentOption = value!);
//               },
//             ),
//             PaymentOptionRow(
//               title: "Pay part now, part later",
//               subtitle: "Pay part now and you're all set",
//               value: 1,
//               groupValue: _selectedPaymentOption,
//               onChanged: (value) {
//                 if (mounted) setState(() => _selectedPaymentOption = value!);
//               },
//             ),
//             const SectionHeader(title: "Pay with"),
//             _buildPaymentMethods(),
//             const Divider(color: Colors.grey, thickness: 1),
//             const SectionHeader(title: "Price Details"),
//             PriceDetailRow(
//               label: "₹$pricePerNight x $nights night${nights > 1 ? 's' : ''}",
//               value: "₹${subtotal.toStringAsFixed(2)}",
//             ),
//             PriceDetailRow(
//               label: "Discount (10%)",
//               value: "-₹${discount.toStringAsFixed(2)}",
//               isDiscount: true,
//             ),
//             PriceDetailRow(
//               label: "Occupancy taxes and fees (5%)",
//               value: "₹${taxes.toStringAsFixed(2)}",
//             ),
//             const Divider(color: Colors.grey, thickness: 1),
//             PriceDetailRow(
//               label: "Grand Total",
//               value: "₹${grandTotal.toStringAsFixed(2)}",
//               isTotal: true,
//             ),
//             Padding(
//               padding: const EdgeInsets.all(10.0),
//               child:
//                   _isProcessingPayment
//                       ? Container(
//                         width: double.infinity,
//                         height: 50,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(10),
//                           color: Colors.grey,
//                         ),
//                         child: const Center(
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               SizedBox(
//                                 width: 20,
//                                 height: 20,
//                                 child: CircularProgressIndicator(
//                                   strokeWidth: 2,
//                                   valueColor: AlwaysStoppedAnimation<Color>(
//                                     Colors.white,
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(width: 10),
//                               Text(
//                                 "Processing Payment...",
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       )
//                       : CustomButton(
//                         text: "Pay Now - ₹${grandTotal.toStringAsFixed(2)}",
//                         width: double.infinity,
//                         height: 50,
//                         onPressed: _processPayment,
//                       ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildPropertyCard() {
//     final hotelName = widget.hotelData?['name'] ?? "Hotel Name";
//     final hotelImage = widget.hotelData?['image'] ?? "assets/images/room1.png";
//     final hotelLocation = widget.hotelData?['location'] ?? "Location";

//     return Padding(
//       padding: const EdgeInsets.all(10.0),
//       child: Container(
//         height: 150,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10),
//           color: Colors.white,
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.1),
//               blurRadius: 10,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Row(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(10.0),
//               child: Stack(
//                 children: [
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(10),
//                     child: Image.asset(
//                       hotelImage,
//                       height: 130,
//                       width: 120,
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                   Positioned(
//                     right: 10,
//                     top: 10,
//                     child: Container(
//                       height: 30,
//                       width: 30,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(10),
//                         color: Colors.white.withOpacity(0.2),
//                       ),
//                       child: const Icon(
//                         Icons.favorite_border,
//                         color: Colors.white,
//                         size: 25,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.only(top: 15.0, right: 10.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       hotelName,
//                       style: const TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Row(
//                       children: [
//                         const Icon(
//                           Icons.location_on_outlined,
//                           color: Colors.black,
//                           size: 16,
//                         ),
//                         const SizedBox(width: 4),
//                         Expanded(
//                           child: Text(
//                             hotelLocation,
//                             style: const TextStyle(
//                               fontSize: 14,
//                               color: Colors.grey,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       guestInfo,
//                       style: const TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       "$nights night${nights > 1 ? 's' : ''}",
//                       style: const TextStyle(
//                         fontSize: 14,
//                         color: Color(0xFF1190F8),
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildPaymentMethods() {
//     return Padding(
//       padding: const EdgeInsets.only(left: 15.0, top: 10.0, right: 15.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 "Payment method",
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//               Text(
//                 "Cash on Delivery",
//                 style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   void _editDates() {
//     if (mounted) Navigator.maybePop(context);
//   }

//   void _editGuests() {
//     if (mounted) Navigator.maybePop(context);
//   }
// }

// // Helper Widgets
// class SectionHeader extends StatelessWidget {
//   final String title;
//   const SectionHeader({super.key, required this.title});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(left: 15.0, top: 10),
//       child: Text(
//         title,
//         style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
//       ),
//     );
//   }
// }

// class EditableInfoRow extends StatelessWidget {
//   final String title;
//   final String value;
//   final VoidCallback onEditPressed;

//   const EditableInfoRow({
//     super.key,
//     required this.title,
//     required this.value,
//     required this.onEditPressed,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(left: 15.0, top: 10.0, right: 15.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: const TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 Text(
//                   value,
//                   style: const TextStyle(fontSize: 18, color: Colors.grey),
//                 ),
//               ],
//             ),
//           ),
//           Container(
//             height: 50,
//             width: 50,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(10),
//               border: Border.all(
//                 width: 2,
//                 color: const Color.fromARGB(255, 17, 144, 248),
//               ),
//             ),
//             child: IconButton(
//               icon: const Icon(
//                 Icons.edit,
//                 size: 30,
//                 color: Color.fromARGB(255, 17, 144, 248),
//               ),
//               onPressed: onEditPressed,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class PaymentOptionRow extends StatelessWidget {
//   final String title;
//   final String subtitle;
//   final int value;
//   final int groupValue;
//   final ValueChanged<int?> onChanged;

//   const PaymentOptionRow({
//     super.key,
//     required this.title,
//     required this.subtitle,
//     required this.value,
//     required this.groupValue,
//     required this.onChanged,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.only(left: 15.0, top: 10.0, right: 15.0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       title,
//                       style: const TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     Text(
//                       subtitle,
//                       style: const TextStyle(fontSize: 17, color: Colors.grey),
//                     ),
//                   ],
//                 ),
//               ),
//               Radio<int>(
//                 value: value,
//                 groupValue: groupValue,
//                 onChanged: onChanged,
//                 activeColor: const Color.fromARGB(255, 17, 144, 248),
//               ),
//             ],
//           ),
//         ),
//         const Divider(color: Colors.grey, thickness: 1),
//       ],
//     );
//   }
// }

// class PriceDetailRow extends StatelessWidget {
//   final String label;
//   final String value;
//   final bool isTotal;
//   final bool isDiscount;

//   const PriceDetailRow({
//     super.key,
//     required this.label,
//     required this.value,
//     this.isTotal = false,
//     this.isDiscount = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 8.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Expanded(
//             child: Text(
//               label,
//               style: TextStyle(
//                 fontSize: isTotal ? 20 : 18,
//                 fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
//               ),
//             ),
//           ),
//           Row(
//             children: [
//               if (!value.startsWith('-'))
//                 const Icon(
//                   Icons.currency_rupee,
//                   size: 16,
//                   color: Colors.black87,
//                 ),
//               Text(
//                 value.startsWith('-') ? value : value.substring(1),
//                 style: TextStyle(
//                   fontSize: isTotal ? 20 : 18,
//                   fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
//                   color: isDiscount ? Colors.green : null,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
