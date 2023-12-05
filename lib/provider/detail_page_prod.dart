import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DetailPageProvider with ChangeNotifier {
  List<Map<String, dynamic>> _trailDataList = [];

  List<Map<String, dynamic>> get trailDataList => _trailDataList;

  Future<void> fetchTrailData() async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      QuerySnapshot querySnapshot = await firestore.collection('trail_data').get();

      List<Map<String, dynamic>> trailDataList = [];

      for (QueryDocumentSnapshot document in querySnapshot.docs) {
        Map<String, dynamic> trailData = document.data() as Map<String, dynamic>;

        String imgName = trailData['img'];
        Reference imageRef = FirebaseStorage.instance.ref().child('$imgName.jpg');
        String downloadURL = await imageRef.getDownloadURL();

        trailData['downloadURL'] = downloadURL;

        trailDataList.add(trailData);
      }
      // print(trailDataList);
      _trailDataList = trailDataList;
      notifyListeners();
    } catch (e) {
      // ignore: avoid_print
      print('Error fetching trail data: $e');
    }
  }
}
