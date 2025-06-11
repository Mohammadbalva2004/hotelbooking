import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BookingService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

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
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

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

      final docRef = await _firestore.collection('bookings').add(bookingData);

      print('Booking created with ID: ${docRef.id}');
      return docRef.id;
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

  // Method to completely delete booking from database
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
      // Get the booking data first
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

      // Add to deleted_bookings collection
      await _firestore
          .collection('deleted_bookings')
          .doc(bookingId)
          .set(bookingData);

      // Delete from original bookings collection
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

  // Keep the old cancel method if you want to maintain cancelled bookings
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
