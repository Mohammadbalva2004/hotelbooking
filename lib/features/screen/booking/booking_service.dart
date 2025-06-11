import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  // Simplified createBooking method with only essential fields
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

  static Future<bool> moveToDeletedBookings(String bookingId) async {
    try {
      final bookingDoc =
          await _firestore.collection('bookings').doc(bookingId).get();

      if (!bookingDoc.exists) {
        print('Booking not found: $bookingId');
        return false;
      }

      final bookingData = bookingDoc.data()!;
      bookingData['deletedAt'] = FieldValue.serverTimestamp();
      bookingData['originalStatus'] = bookingData['status'];
      bookingData['status'] = 'deleted';

      await _firestore
          .collection('deleted_bookings')
          .doc(bookingId)
          .set(bookingData);

      await _firestore.collection('bookings').doc(bookingId).delete();

      print(
        'Booking moved to deleted_bookings and removed from bookings: $bookingId',
      );
      return true;
    } catch (e) {
      print('Error moving booking to deleted: $e');
      return false;
    }
  }
}
