// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api, no_leading_underscores_for_local_identifiers, avoid_print

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({Key? key}) : super(key: key);

  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late String _imageUrl;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _imageUrl = '';

    getUserData();
  }

  Future<void> getUserData() async {
    DocumentReference userDocRef = await _firestore
        .collection('users')
        .where('email', isEqualTo: _auth.currentUser?.email)
        .get()
        .then((snapshot) => snapshot.docs.first.reference);

    DocumentSnapshot userData = await userDocRef.get();

    setState(() {
      _nameController.text = userData['name'];
      _emailController.text = userData['email'];
      _imageUrl = userData['img'] ?? '';
    });
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      // Upload gambar ke Firebase Storage
      File file = File(image.path);
      String fileName = 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
      Reference storageRef = _storage.ref().child('profile_images/$fileName');
      await storageRef.putFile(file);

      String imageUrl = fileName.substring(0, fileName.lastIndexOf('.'));

      setState(() {
        _imageUrl = imageUrl;
      });

      await _updateImageInFirestore(imageUrl);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Image uploaded successfully',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.blue,
        ),
      );
    }
  }

  Future<void> _updateImageInFirestore(String imageUrl) async {
    try {
      DocumentReference userDocRef = await _firestore
          .collection('users')
          .where('email', isEqualTo: _auth.currentUser?.email)
          .get()
          .then((snapshot) => snapshot.docs.first.reference);

      await userDocRef.update({
        'img': imageUrl,
      });
    } catch (e) {
      print('Error updating image URL in Firestore: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Failed to update image URL',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _imageUrl.isNotEmpty
                        ? NetworkImage('https://firebasestorage.googleapis.com/v0/b/travel-app-a01eb.appspot.com/o/profile_images%2F$_imageUrl.jpg?alt=media&token=0cdd355f-aa19-4496-8824-a70c09ae4be2')
                        : const NetworkImage(
                            'https://cdn.discordapp.com/attachments/1100056342317760523/1181590241300189307/zeta.jpg'),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  readOnly: true,
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    saveChanges();
                  },
                  child: const Text('Save Changes'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> saveChanges() async {
    try {
      DocumentReference userDocRef = await _firestore
          .collection('users')
          .where('email', isEqualTo: _auth.currentUser?.email)
          .get()
          .then((snapshot) => snapshot.docs.first.reference);

      await userDocRef.update({
        'name': _nameController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Changes saved successfully',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.blue,
        ),
      );
    } catch (e) {
      print('Error saving changes: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Failed to save changes',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
