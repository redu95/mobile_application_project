import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class BookingDemo extends StatefulWidget {
  final String hotelName;
  final String roomName;
  final String roomPrice;
  final List<String> imageUrls;
  final List<String> roomNames; // Add roomNames parameter
  final List<String> roomPrices; // Add roomPrices parameter
  final List<String> roomImages; // Add roomImages parameter

  const BookingDemo({
    Key? key,
    required this.hotelName,
    required this.roomName,
    required this.roomPrice,
    required this.imageUrls,
    required this.roomNames, // Add roomNames parameter
    required this.roomPrices, // Add roomPrices parameter
    required this.roomImages, // Add roomImages parameter
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
  String? _selectedRoomPreference;
  String? _selectedHotel;

  @override
  void initState() {
    super.initState();
    _selectedHotel = widget.hotelName; // Set initial hotel name
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

  // Function for submitting bookings
  Future<void> _submitBooking() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance.collection('bookings').add({
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
          'created_at': FieldValue.serverTimestamp(),
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Booking successful!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to book. Please try again later.')),
        );
      }
    }
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
                Image.asset(
                  'assets/images/hotel_im/hotel.jpg',
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
                    "price per night :\$ ${widget.roomPrice}",
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
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _numberOfChildrenController,
                g          decoration: const InputDecoration(
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
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Total price: ",
                    style: TextStyle(fontSize: 35),
                  ),
              const SizedBox(height: 32),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Submit the form
                      _submitBooking();
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
