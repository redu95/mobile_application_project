import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import for user authentication

class BookingDemo extends StatefulWidget {
  final String hotelName;
  final String hotelId;
  final String roomName;
  final int roomPrice;
  final String imageUrl;

  const BookingDemo({
    Key? key,
    required this.hotelName,
    required this.hotelId,
    required this.roomName,
    required this.roomPrice,
    required this.imageUrl,
  }) : super(key: key);

  @override
  State<BookingDemo> createState() => _BookingDemoState();
}

class _BookingDemoState extends State<BookingDemo> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _checkInDateController = TextEditingController();
  final _checkInTimeController = TextEditingController();
  final _checkOutDateController = TextEditingController();
  final _checkOutTimeController = TextEditingController();
  final _adultsController = TextEditingController();
  final _numberOfChildrenController = TextEditingController();

  DateTime? _selectedCheckInDate;
  TimeOfDay? _selectedCheckInTime;
  DateTime? _selectedCheckOutDate;
  TimeOfDay? _selectedCheckOutTime;
  int? _selectedAdults;
  int? _numberOfChildren;
  String? _selectedRoomPreference;
  int _totalPrice = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _checkInDateController.dispose();
    _checkOutDateController.dispose();
    _adultsController.dispose();
    _numberOfChildrenController.dispose();
    super.dispose();
  }

  void _updateTotalPrice() {
    if (_selectedCheckInDate != null && _selectedCheckOutDate != null && _selectedAdults != null) {
      int numberOfNights = _selectedCheckOutDate!.difference(_selectedCheckInDate!).inDays;
      int roomsNeeded = (_selectedAdults! / 2).ceil();
      setState(() {
        _totalPrice = widget.roomPrice * numberOfNights * roomsNeeded;
      });
    }
  }

  Future<void> _submitBooking() async {
    if (_formKey.currentState!.validate()) {
      try {
        String userId = FirebaseAuth.instance.currentUser!.uid;
        DateTime checkInDate = DateFormat('MM/dd/yyyy').parse(_checkInDateController.text);
        DateTime checkOutDate = DateFormat('MM/dd/yyyy').parse(_checkOutDateController.text);

        await FirebaseFirestore.instance.collection('bookings').add({
          'user_id': userId,
          'hotel_id': widget.hotelId,
          'guest_name': _firstNameController.text + ' ' + _lastNameController.text,
          'guest_contact': _phoneController.text,
          'guest_email': _emailController.text,
          'check_in': {
            'date': _checkInDateController.text,
            'time': _checkInTimeController.text,
          },
          'check_out': {
            'date': _checkOutDateController.text,
            'time': _checkOutTimeController.text,
          },
          'location': {
            'city': _cityController.text,
            'state': _stateController.text,
          },
          'room_preference': _selectedRoomPreference,
          'room_type': widget.roomName,
          'number_of_adults': _selectedAdults,
          'number_of_children': _numberOfChildren,
          'total_price': _totalPrice,
          'status': 'Pending',
          'created_at': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Booking Request successfully Sent!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to book. Please try again later.')),
        );
      }
    }
  }

  Future<void> _confirmBooking() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap a button to dismiss the dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Booking'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to proceed with the booking?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Confirm'),
              onPressed: () {
                Navigator.of(context).pop();
                _submitBooking();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Booking'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Stack(
              children: [
                Image.network(
                  widget.imageUrl,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: Text(
                    "Booking for ${widget.hotelName}",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      backgroundColor: Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 26),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Text(
                    "Room Type: ${widget.roomName}",
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Price per night: \$${widget.roomPrice}",
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _firstNameController,
                    decoration: const InputDecoration(
                      labelText: 'First Name *',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your first name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _lastNameController,
                    decoration: const InputDecoration(
                      labelText: 'Last Name *',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your last name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _cityController,
                          decoration: const InputDecoration(
                            labelText: 'City *',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your city';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _stateController,
                          decoration: const InputDecoration(
                            labelText: 'State *',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your state';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _phoneController,
                          decoration: const InputDecoration(
                            labelText: 'Phone *',
                            prefixText: '(',
                            suffixText: ')',
                          ),
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your phone number';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            labelText: 'Email Address *',
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email address';
                            }
                            if (!value.contains('@')) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _checkInDateController,
                          decoration: const InputDecoration(
                            labelText: 'Check-in Date *',
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                          readOnly: true,
                          onTap: () async {
                            _selectedCheckInDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2100),
                            );
                            if (_selectedCheckInDate != null) {
                              _checkInDateController.text = DateFormat('MM/dd/yyyy').format(_selectedCheckInDate!);
                              _updateTotalPrice();
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _checkInTimeController,
                          decoration: const InputDecoration(
                            labelText: 'Check-in Time *',
                            suffixIcon: Icon(Icons.access_time),
                          ),
                          readOnly: true,
                          onTap: () async {
                            _selectedCheckInTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (_selectedCheckInTime != null) {
                              _checkInTimeController.text = _selectedCheckInTime!.format(context);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _checkOutDateController,
                          decoration: const InputDecoration(
                            labelText: 'Check-out Date *',
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                          readOnly: true,
                          onTap: () async {
                            _selectedCheckOutDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2100),
                            );
                            if (_selectedCheckOutDate != null) {
                              _checkOutDateController.text = DateFormat('MM/dd/yyyy').format(_selectedCheckOutDate!);
                              _updateTotalPrice();
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _checkOutTimeController,
                          decoration: const InputDecoration(
                            labelText: 'Check-out Time *',
                            suffixIcon: Icon(Icons.access_time),
                          ),
                          readOnly: true,
                          onTap: () async {
                            _selectedCheckOutTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (_selectedCheckOutTime != null) {
                              _checkOutTimeController.text = _selectedCheckOutTime!.format(context);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _adultsController,
                          decoration: const InputDecoration(
                            labelText: 'Number of Adults *',
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the number of adults';
                            }
                            if (int.tryParse(value) == null || int.parse(value)! <= 0) {
                              return 'Please enter a valid number';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            _selectedAdults = int.tryParse(value);
                            _updateTotalPrice();
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _numberOfChildrenController,
                         decoration: const InputDecoration(
                            labelText: 'Number of Children *',
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the number of children';
                            }
                            if (int.tryParse(value) == null || int.parse(value)! < 0) {
                              return 'Please enter a valid number';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            _numberOfChildren = int.tryParse(value);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Total price: \$$_totalPrice",
                    style: TextStyle(fontSize: 35),
                  ),
                  const SizedBox(height: 32),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _confirmBooking();
                        }
                      },
                      child: const Text('Book Now'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
