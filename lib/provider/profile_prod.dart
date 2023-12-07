import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_app/model/profile.dart';

class MyProfileProvider extends ChangeNotifier {
  UserProfile? _userProfile;

  UserProfile? get userProfile => _userProfile;

  Future<void> fetchUserProfile(String email) async {
    // Ambil data dari Firestore berdasarkan email
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get()
        .then((snapshot) => snapshot.docs.first);

    // Map data Firestore ke dalam objek UserProfile
    _userProfile = UserProfile(
      name: userSnapshot['name'],
      email: userSnapshot['email'],
      memberSince: (userSnapshot['acc_created'] as Timestamp).toDate(),
      // tambahkan properti lain sesuai kebutuhan
    );

    notifyListeners();
  }
}

