import 'package:flutter/material.dart';
import 'package:hotelbooking/features/screen/payment/payment_screen.dart';

class PaymentSuccessScreen extends StatefulWidget {
  final Map<String, dynamic> bookingDetails;

  const PaymentSuccessScreen({Key? key, required this.bookingDetails})
    : super(key: key);

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen> {
  bool _isCreatingBooking = true;
  String? _bookingId;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _createBooking();
  }

  Future<void> _createBooking() async {
    try {
      final bookingId = await BookingService.createBooking(
        hotelId: widget.bookingDetails['hotelId'],
        hotelName: widget.bookingDetails['hotelName'],
        hotelLocation: widget.bookingDetails['hotelLocation'],
        hotelImage: widget.bookingDetails['hotelImage'],
        hotelRating: widget.bookingDetails['hotelRating'],
        hotelReviewCount: widget.bookingDetails['hotelReviewCount'],
        checkInDate: widget.bookingDetails['checkInDate'],
        checkOutDate: widget.bookingDetails['checkOutDate'],
        checkInTime: widget.bookingDetails['checkInTime'] ?? '2:00 PM',
        checkOutTime: widget.bookingDetails['checkOutTime'] ?? '11:00 AM',
        nights: widget.bookingDetails['nights'],
        adults: widget.bookingDetails['adults'],
        infants: widget.bookingDetails['infants'],
        children: widget.bookingDetails['children'] ?? 0,
        pricePerNight: widget.bookingDetails['pricePerNight'],
        discount: widget.bookingDetails['discount'] ?? 0,
        taxes: widget.bookingDetails['taxes'] ?? 0,
        totalPrice: widget.bookingDetails['totalPrice'],
      );

      setState(() {
        _isCreatingBooking = false;
        _bookingId = bookingId;
      });
    } catch (e) {
      setState(() {
        _isCreatingBooking = false;
        _errorMessage = 'Failed to create booking: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Confirmation'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child:
              _isCreatingBooking
                  ? const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 20),
                      Text('Creating your booking...'),
                    ],
                  )
                  : _bookingId != null
                  ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 80,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Booking Confirmed!',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Booking ID: $_bookingId',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/bookings',
                            (route) => false,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 15,
                          ),
                        ),
                        child: const Text(
                          'View My Bookings',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/home',
                            (route) => false,
                          );
                        },
                        child: const Text('Back to Home'),
                      ),
                    ],
                  )
                  : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 80,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Booking Failed',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _errorMessage,
                        style: const TextStyle(fontSize: 16, color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 15,
                          ),
                        ),
                        child: const Text(
                          'Try Again',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
        ),
      ),
    );
  }
}
