import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

Future<List<Map<String, dynamic>>> fetchTrailData() async {
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

    return trailDataList;
  } catch (e) {
    // ignore: avoid_print
    print('Error fetching trail data: $e');
    return [];
  }
}
