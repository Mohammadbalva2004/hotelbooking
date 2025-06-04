import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BookingService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Create a new booking in Firebase
  static Future<String?> createBooking({
    required String hotelId,
    required String hotelName,
    required String hotelLocation,
    required String hotelImage,
    required double hotelRating,
    required int hotelReviewCount,
    required String checkInDate,
    required String checkOutDate,
    required String checkInTime,
    required String checkOutTime,
    required int nights,
    required int adults,
    required int children,
    required double pricePerNight,
    required double discount,
    required double taxes,
    required double totalPrice,
  }) async {
    try {
      // Check if user is logged in
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      // Create booking data
      final bookingData = {
        'userId': user.uid,
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
        'status': 'confirmed',
        'createdAt': FieldValue.serverTimestamp(),
      };

      // Add to Firestore
      final docRef = await _firestore.collection('bookings').add(bookingData);

      print('Booking created with ID: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      print('Error creating booking: $e');
      return null;
    }
  }

  // Get a specific booking
  static Future<Map<String, dynamic>?> getBooking(String bookingId) async {
    try {
      final doc = await _firestore.collection('bookings').doc(bookingId).get();
      if (doc.exists) {
        return doc.data();
      }
      return null;
    } catch (e) {
      print('Error getting booking: $e');
      return null;
    }
  }

  // Cancel a booking
  static Future<bool> cancelBooking(String bookingId) async {
    try {
      await _firestore.collection('bookings').doc(bookingId).update({
        'status': 'cancelled',
      });
      return true;
    } catch (e) {
      print('Error cancelling booking: $e');
      return false;
    }
  }
}
