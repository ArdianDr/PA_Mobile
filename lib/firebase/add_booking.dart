// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddBooking {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveBooking(
      Map<String, dynamic> bookingData) async {
    // Mendapatkan email pengguna dari FirebaseAuth
    FirebaseAuth auth = FirebaseAuth.instance;
    String userEmail = auth.currentUser?.email ?? "";
    try {
      DocumentReference userDocRef = await _firestore
          .collection('users')
          .where('email', isEqualTo: userEmail)
          .get()
          .then((snapshot) => snapshot.docs.first.reference);

      await userDocRef.collection('booking').add(bookingData);

      print('Booking placed successfully.');
    } catch (error) {
      print('Error placing booking: $error');
    }
  }
}
