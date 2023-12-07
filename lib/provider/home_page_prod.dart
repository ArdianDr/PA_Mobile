// ignore_for_file: avoid_print

import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../firebase/fetchUser.dart';

class HomePageProvider with ChangeNotifier {
  List<Map<String, dynamic>> _trailDataList = [];
  List<Map<String, dynamic>> _inspirationDataList = [];

  List<Map<String, dynamic>> get trailDataList => _trailDataList;
  List<Map<String, dynamic>> get inspirationDataList => _inspirationDataList;

  Future<void> fetchTrailData() async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      QuerySnapshot querySnapshot =
          await firestore.collection('trail_data').get();

      List<Map<String, dynamic>> trailDataList = [];

      for (QueryDocumentSnapshot document in querySnapshot.docs) {
        Map<String, dynamic> trailData =
            document.data() as Map<String, dynamic>;

        String imgName = trailData['img'];
        Reference imageRef =
            FirebaseStorage.instance.ref().child('$imgName.jpg');
        String downloadURL = await imageRef.getDownloadURL();

        trailData['downloadURL'] = downloadURL;

        trailDataList.add(trailData);
      }
      _trailDataList = trailDataList;
      notifyListeners();
    } catch (e) {
      print('Error fetching trail data: $e');
    }
  }

  Future<void> fetchInspirationData() async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      QuerySnapshot querySnapshot = await firestore
          .collection('inspiration')
          .orderBy('createdAt', descending: false)
          .get();

      List<Map<String, dynamic>> inspirationDataList = [];

      for (QueryDocumentSnapshot document in querySnapshot.docs) {
        Map<String, dynamic> inspirationData =
            document.data() as Map<String, dynamic>;
        inspirationDataList.add(inspirationData);
      }

      _inspirationDataList = inspirationDataList;
      // print(_inspirationDataList);
      notifyListeners();
    } catch (e) {
      print('Error fetching inspiration data: $e');
    }
  }

  Future<String?> fetchName() async {
    Map<String, dynamic>? userData = await fetchUserData();
    String? userName = userData['name'];

// Now you can use `userName` as needed.

    try {
      return userName;
    } catch (e) {
      print("Error fetching user data: $e");
      return null;
    }
  }

  Future<bool> deleteComment(Timestamp commentTime) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      DocumentReference commentDocRef = await firestore
          .collection('inspiration')
          .where('createdAt', isEqualTo: commentTime)
          .get()
          .then((snapshot) => snapshot.docs.first.reference);

      await commentDocRef.delete();
      await fetchInspirationData();
      return true;
    } catch (e) {
      print('Error deleting comment: $e');
      return false;
    }
  }

  Future<void> addComment(String commentText) async {
    try {
      // Fetch user data
      Map<String, dynamic>? userData = await fetchUserData();
      String? userName = userData['name'];
      String? userImg = userData['img'];


// Now you can use `userName` as needed.

      // Validate that the comment is not empty
      if (userName != null && commentText.isNotEmpty) {
        // Create a reference to the 'inspiration' collection
        CollectionReference inspirationCollection =
            FirebaseFirestore.instance.collection('inspiration');

        // Add a new document with data
        await inspirationCollection.add({
          'name': userName,
          'comments': commentText,
          'createdAt': Timestamp.now(),
          'profile_img': userImg
        });

        // Fetch updated inspiration data
        await fetchInspirationData();

        // Notify listeners about the change
        notifyListeners();
      }
    } catch (error) {
      print('Error adding comment: $error');
      // Handle the error as needed
    }
  }
}
