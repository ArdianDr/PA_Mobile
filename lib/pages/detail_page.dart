// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_app/firebase/add_booking.dart';
// import 'package:travel_app/pages/booking_page.dart';
import 'package:travel_app/provider/settings_screen.dart';
import 'package:travel_app/widgets/app_button.dart';
import 'package:travel_app/widgets/app_large_text.dart';
import 'package:travel_app/widgets/app_text.dart';
import '../misc/colors.dart';

class DetailPage extends StatefulWidget {
  final Map<String, dynamic> data;

  const DetailPage({Key? key, required this.data}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  int _numberOfPeople = 1;
  DateTime _bookingDate =
      DateTime.now().add(const Duration(days: 1)); // Default: besok

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _bookingDate,
      firstDate: DateTime.now().add(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (pickedDate != null && pickedDate != _bookingDate) {
      setState(() {
        _bookingDate = pickedDate;
        _bookingDateController.text =
            _bookingDate.toLocal().toString().split(' ')[0];
      });
    }
  }

  final TextEditingController _bookingDateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppLargeText(text: widget.data['name']),
      ),
      body: SizedBox(
        width: double.maxFinite,
        height: double.maxFinite,
        child: Stack(
          children: [
            Positioned(
                left: 0,
                child: Container(
                  width: 470,
                  height: 350,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(
                            "https://firebasestorage.googleapis.com/v0/b/travel-app-a01eb.appspot.com/o/${widget.data['img']}.jpg?alt=media&token=3001d812-e439-40e3-9def-f2066271bc19"),
                        fit: BoxFit.cover),
                  ),
                )),
            Positioned(
              top: 250,
              child: Container(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 30,
                ),
                width: MediaQuery.of(context).size.width,
                height: 500,
                decoration: BoxDecoration(
                  color: context.watch<ThemeModeData>().isDarkModeActive
                      ? const Color.fromARGB(255, 28, 27, 31)
                      : Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          AppLargeText(
                            text: widget.data['name'],
                          ),
                          Text(
                            " \$${widget.data['price']}",
                            style: TextStyle(
                              fontSize: 30,
                              color: AppColors.mainColor,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: AppColors.mainColor,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          AppText(
                            text: widget.data['location'],
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Wrap(
                            children: List.generate(5, (index) {
                              return Icon(Icons.star,
                                  color: index < widget.data["stars"]
                                      ? AppColors.starColor
                                      : AppColors.textColor2);
                            }),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          AppText(
                            text: "(${widget.data['stars']}.0)",
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      AppLargeText(
                        text: "Description",
                        size: 20,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        widget.data['description'],
                        style: TextStyle(
                            color:
                                context.watch<ThemeModeData>().isDarkModeActive
                                    ? AppColors.textColor2
                                    : AppColors.textColor1,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Row(
                children: [
                  AppButtons(
                    size: 60,
                    color: AppColors.textColor1,
                    backgroundColor:
                        context.watch<ThemeModeData>().isDarkModeActive
                            ? const Color.fromARGB(255, 28, 27, 31)
                            : Colors.white,
                    borderColor: AppColors.textColor1,
                    isIcon: true,
                    icon: Icons.favorite_border,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return StatefulBuilder(
                              builder: (context, setState) {
                                return Form(
                                  key: _formKey,
                                  child: Container(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        // Formulir input dan elemen-elemen lainnya di sini
                                        // Contoh:
                                        AppText(text: "Input Information"),
                                        const SizedBox(height: 20),
                                        TextFormField(
                                          controller: _nameController,
                                          decoration: const InputDecoration(
                                            labelText: 'Recipient Name',
                                            prefixIcon: Icon(Icons.person),
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter recipient name';
                                            }
                                            RegExp regExp = RegExp(
                                                r'[0-9!@#%^&*(),.?":{}|<>]');
                                            if (regExp.hasMatch(value)) {
                                              return 'Name cannot contain numbers or symbols';
                                            }

                                            return null;
                                          },
                                        ),

                                        const SizedBox(height: 10),
                                        TextFormField(
                                          controller: _phoneNumberController,
                                          keyboardType: TextInputType.phone,
                                          decoration: const InputDecoration(
                                            labelText: 'Active Phone Number',
                                            prefixIcon: Icon(Icons.phone),
                                          ),
                                          validator: (value) {
                                            RegExp regExp = RegExp(r'[a-zA-Z]');
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter phone number';
                                            } else if (value.length < 11 ||
                                                value.length >= 13) {
                                              return 'Please enter valid phone number';
                                            } else if (regExp.hasMatch(value)) {
                                              return 'Invalid characters in phone number';
                                            }
                                            return null;
                                          },
                                        ),
                                        const SizedBox(height: 10),
                                        const Text('Number of People'),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.remove),
                                              onPressed: () {
                                                setState(() {
                                                  _numberOfPeople =
                                                      (_numberOfPeople > 1)
                                                          ? _numberOfPeople - 1
                                                          : 1;
                                                });
                                              },
                                            ),
                                            Text('$_numberOfPeople'),
                                            IconButton(
                                              icon: const Icon(Icons.add),
                                              onPressed: () {
                                                setState(() {
                                                  _numberOfPeople =
                                                      (_numberOfPeople < 10)
                                                          ? _numberOfPeople + 1
                                                          : 10;
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                        TextFormField(
                                          controller: _bookingDateController,
                                          onTap: () {
                                            _selectDate(context);
                                          },
                                          readOnly: true,
                                          decoration: const InputDecoration(
                                            labelText: 'Booking Date',
                                            prefixIcon:
                                                Icon(Icons.date_range_outlined),
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please select booking date';
                                            }
                                            // You can add more specific validation logic if needed
                                            return null;
                                          },
                                        ),

                                        const SizedBox(height: 20),

                                        ElevatedButton(
                                          onPressed: () async {
                                            if (_formKey.currentState
                                                    ?.validate() ??
                                                false) {
                                              // Menyiapkan data untuk disimpan
                                              Map<String, dynamic> bookingData =
                                                  {
                                                'recipientName':
                                                    _nameController.text,
                                                'phoneNumber':
                                                    _phoneNumberController.text,
                                                'numberOfPeople':
                                                    _numberOfPeople,
                                                'bookingDate': Timestamp
                                                    .fromDate(DateTime.parse(
                                                        _bookingDateController
                                                            .text)),
                                                'chosenTrail': {
                                                  'img': widget.data['img'],
                                                  'name': widget.data['name'],
                                                  'location':
                                                      widget.data['location'],
                                                  'price': widget.data['price'],
                                                },
                                                'totalPrice': _numberOfPeople *
                                                    widget.data['price'],
                                                'createdAt': DateTime.now(),
                                                'updatedAt': DateTime.now()
                                              };

                                              await AddBooking()
                                                  .saveBooking(bookingData);
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    "Booking placed successfully.",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  duration:
                                                      Duration(seconds: 3),
                                                  backgroundColor: Colors.blue,
                                                ),
                                              );
                                              Navigator.pop(context);
                                            }
                                          },
                                          child: const Text('Submit'),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                      child: Container(
                        width: double.maxFinite,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.blue,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(left: 20),
                              child: const Text(
                                "Book Trip Now",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                                // color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
