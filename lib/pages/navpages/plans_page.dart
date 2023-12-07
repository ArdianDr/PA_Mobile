// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api, avoid_print

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:travel_app/widgets/app_large_text.dart';

class PlansPage extends StatefulWidget {
  const PlansPage({super.key});

  @override
  _PlansPageState createState() => _PlansPageState();
}

class _PlansPageState extends State<PlansPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: AppLargeText(text: "My Plans"),
      //   centerTitle: true,
      // ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('users')
                  .where('email', isEqualTo: _auth.currentUser?.email)
                  .snapshots(),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                // if (!userSnapshot.hasData || userSnapshot.data!.docs.isEmpty) {
                //   return const Text('Total Plans: 0');
                // }

                var userDoc = userSnapshot.data!.docs.first;
                var userId = userDoc.id;

                return StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection('users')
                      .doc(userId)
                      .collection('booking')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }

                    if (!snapshot.hasData) {
                      return Container();
                    } else {
                      var booking = snapshot.data!.docs;
                      var totalBooking = booking.length;

                      return SafeArea(child: AppLargeText(text: 'Total Plans: $totalBooking'));
                    }
                  },
                );
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<DocumentReference>(
              future: _firestore
                  .collection('users')
                  .where('email', isEqualTo: _auth.currentUser?.email)
                  .get()
                  .then((snapshot) => snapshot.docs.first.reference),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (!userSnapshot.hasData) {
                  return const Center(
                    child: Text("You haven't add a plan yet."),
                  );
                }

                return StreamBuilder<QuerySnapshot>(
                  stream: userSnapshot.data!
                      .collection('booking')
                      .orderBy('createdAt', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    var booking = snapshot.data!.docs;

                    if (booking.isEmpty) {
                      return const Center(
                        child: Text("You haven't add a plan yet."),
                      );
                    }

                    return ListView.builder(
                      itemCount: booking.length,
                      itemBuilder: (context, index) {
                        var plan = booking[index];
                        return OrderCard(
                          plan: plan,
                          onEdit: () {
                            _showEditOrderDialog(context, plan);
                          },
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

void _showEditOrderDialog(
    BuildContext context, QueryDocumentSnapshot<Object?> plan) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return OrderEditDialog(
        plan: plan,
        onUpdate: (newRecipientName, phoneNumber, newQuantity, newDate) {
          _updateOrder(
              plan, newRecipientName, phoneNumber, newQuantity, newDate);
          Navigator.of(context).pop();
        },
      );
    },
  );
}

void _updateOrder(
  QueryDocumentSnapshot<Object?> plan,
  String newRecipientName,
  int phoneNumber,
  int newQuantity,
  Timestamp newDate,
) async {
  try {
    int price = plan['chosenTrail']['price'];

    int newTotalPrice = price * newQuantity;

    await plan.reference.update({
      'recipientName': newRecipientName,
      'bookingDate': newDate,
      'numberOfPeople': newQuantity,
      'totalPrice': newTotalPrice,
      'updatedAt': DateTime.now()
    });
  } catch (e) {
    print('Error updating plan: $e');
  }
}

class OrderCard extends StatelessWidget {
  final QueryDocumentSnapshot<Object?> plan;
  final VoidCallback onEdit;

  const OrderCard({
    Key? key,
    required this.plan,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime date = (plan['bookingDate'] as Timestamp).toDate();

    // Format the DateTime as a string
    String formattedDate = DateFormat.yMMMd().format(date);

    return Card(
      margin: const EdgeInsets.all(10),
      child: ListTile(
        onTap: () {
          _showOrderDetails(context);
        },
        title: Text('Trail Name: ${plan['chosenTrail']['name']}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Total Price: \$${plan['totalPrice']}'),
            Text('Booking Plan Date: $formattedDate'),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                _showDeleteConfirmationDialog(context, plan);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showOrderDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Plan Details'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Recipient Name: ${plan['recipientName']}'),
              Text('Phone Number: ${plan['phoneNumber']}'),
              // Image.network(plan['chosenTrail']['imagePath']),
              Text('Chosen Trail: ${plan['chosenTrail']['name']}'),
              // Text('Price: ${plan['chosenTrail']['price']}'),
              Text('Number of People: ${plan['numberOfPeople']}'),
              Text('Total Price: \$${plan['totalPrice']}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

void _showDeleteConfirmationDialog(
    BuildContext context, QueryDocumentSnapshot<Object?> plan) {
  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: const Text('Cancel Plan'),
        content: const Text('Are you sure you want to cancel this plan?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
            },
            child: const Text('Nevermind'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              _deleteOrder(dialogContext, plan);
            },
            child: const Text('Cancel Now'),
          ),
        ],
      );
    },
  );
}

void _deleteOrder(
    BuildContext context, QueryDocumentSnapshot<Object?> plan) async {
  try {
    await plan.reference.delete();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cancelled'),
          content: const Text('Booking plan has been successfully cancelled.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  } catch (e) {
    print('Error deleting plan: $e');
  }
}

class OrderEditDialog extends StatefulWidget {
  final QueryDocumentSnapshot<Object?> plan;
  final Function(String, int, int, Timestamp) onUpdate;

  const OrderEditDialog({
    Key? key,
    required this.plan,
    required this.onUpdate,
  }) : super(key: key);

  @override
  _OrderEditDialogState createState() => _OrderEditDialogState();
}

class _OrderEditDialogState extends State<OrderEditDialog> {
  late TextEditingController recipientNameController;
  late TextEditingController phoneController;
  late TextEditingController peopleController;
  final _formKey = GlobalKey<FormState>();

  DateTime? _pickedDate;

  Future<void> _selectDate(BuildContext context) async {
    DateTime oldDate = widget.plan['bookingDate'].toDate();
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: oldDate,
      firstDate: DateTime.now().add(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (pickedDate != null && pickedDate != oldDate) {
      setState(() {
        _pickedDate = pickedDate; // Simpan tanggal yang dipilih
        _bookingDateController.text =
            _pickedDate!.toLocal().toString().split(' ')[0];
      });
    }
  }

  final TextEditingController _bookingDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    recipientNameController =
        TextEditingController(text: widget.plan['recipientName']);
    phoneController =
        TextEditingController(text: widget.plan['phoneNumber'].toString());
    peopleController =
        TextEditingController(text: widget.plan['numberOfPeople'].toString());
    _pickedDate = widget.plan['bookingDate']
        .toDate(); 
    _bookingDateController.text =
        _pickedDate!.toLocal().toString().split(' ')[0];
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Plan'),
      content: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: recipientNameController,
              decoration: const InputDecoration(
                labelText: 'Recipient Name',
                prefixIcon: Icon(Icons.person),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter recipient name';
                }
                RegExp regExp = RegExp(r'[0-9!@#%^&*(),.?":{}|<>]');
                if (regExp.hasMatch(value)) {
                  return 'Name cannot contain numbers or symbols';
                }
                return null;
              },
            ),
            TextFormField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                prefixIcon: Icon(Icons.phone),
              ),
              validator: (value) {
                RegExp regExp = RegExp(r'[a-zA-Z]');
                if (value == null || value.isEmpty) {
                  return 'Please enter phone number';
                } else if (value.length < 11 || value.length >= 13) {
                  return 'Please enter valid phone number';
                } else if (regExp.hasMatch(value)) {
                  return 'Invalid characters in phone number';
                }
                return null;
              },
            ),
            TextFormField(
              controller: peopleController,
              decoration: const InputDecoration(
                labelText: 'Number of People',
                prefixIcon: Icon(Icons.person_add),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a number';
                }
                final quantity = int.tryParse(value);
                if (quantity == null || quantity <= 0) {
                  return 'Min 1 People';
                }
                if (quantity > 10) {
                  return 'Max 10 People';
                }
                return null;
              },
            ),
            Text('Current Total Price: \$${widget.plan['totalPrice']}'),
            TextFormField(
              controller: _bookingDateController,
              onTap: () {
                _selectDate(context);
              },
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Booking Date',
                prefixIcon: Icon(Icons.date_range_outlined),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select booking date';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              widget.onUpdate(
                recipientNameController.text,
                int.parse(phoneController.text),
                int.parse(peopleController.text),
                Timestamp.fromDate(DateTime.parse(_bookingDateController.text)),
              );
              // Navigator.of(context).pop();
            }
          },
          child: const Text('Update'),
        ),
      ],
    );
  }
}
