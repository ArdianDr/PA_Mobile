// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BookingPage extends StatefulWidget {
  final DocumentReference trailData;

  const BookingPage({Key? key, required this.trailData}) : super(key: key);

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final _nameController = TextEditingController();
  final _peopleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Trail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _dateController,
                decoration: const InputDecoration(labelText: 'Date'),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2101),
                  );

                  if (pickedDate != null && pickedDate != DateTime.now()) {
                    _dateController.text =
                        pickedDate.toLocal().toString().split(' ')[0];
                  }
                },
              ),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Your Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _peopleController,
                decoration: const InputDecoration(labelText: 'Number of People'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the number of people';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    String uid = FirebaseAuth.instance.currentUser!.uid;
                    await FirebaseFirestore.instance
                        .collection('booking_data')
                        .add({
                      'UID': uid,
                      'date': Timestamp.fromDate(
                          DateTime.parse(_dateController.text)),
                      'name': _nameController.text,
                      'people': int.parse(_peopleController.text),
                      'trail_id': widget.trailData,
                    });

                    // Show a success message or navigate to another page
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Booking Successful!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                },
                child: const Text('Book Now'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
