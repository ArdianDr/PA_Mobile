// ignore_for_file: file_names, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

FirebaseAuth _auth = FirebaseAuth.instance;
FirebaseFirestore _firestore = FirebaseFirestore.instance;

Future<Map<String, dynamic>> fetchUserData() async {
  String userEmail = _auth.currentUser?.email ?? "";

  try {
    DocumentSnapshot userSnapshot = await _firestore
        .collection('users')
        .where('email', isEqualTo: userEmail)
        .get()
        .then((snapshot) => snapshot.docs.first);

    String userName = userSnapshot['name'];
    String avatarUrl = userSnapshot['img'] ?? '';

    return {'name': userName, 'img': avatarUrl};
  } catch (e) {
    print("Error fetching user data: $e");
    return {'name': null, 'img': null};
  }
}
