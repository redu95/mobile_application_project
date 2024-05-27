import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookingDemo extends StatefulWidget {
  const BookingDemo({Key? key}) : super(key: key);

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
  final _checkOutDateController = TextEditingController();
  final _adultsController = TextEditingController();
  final _numberOfChildren = TextEditingController(); // Updated controller

  String? _selectedRoomPreference;
  String? _selectedHotel;

  final List<String> _hotels = [
    'Sheraton Hotel',
    'Hilton Hotel',
    'Capital Hotel',
    'Skylight Hotel',
    'Harmony Hotel',
    'Sky City Hotel',
    'Ilili Hotel'
  ];

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
    _numberOfChildren.dispose();
    super.dispose();
  }

  Future<void> _submitBooking() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance.collection('bookings').add({
          'guest_name': _firstNameController.text + ' ' + _lastNameController.text,
          'guest_contact': _phoneController.text,
          'guest_email': _emailController.text,
          'check_in': {
            'date': _checkInDateController.text,

          },
          'check_out': {
            'date': _checkOutDateController.text,

          },
          'location': {
            'city': _cityController.text,
            'state': _stateController.text,
          },
          'room_preference': _selectedRoomPreference,

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
        title: const Text('Booking'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        Stack(
        children: [
        Image.asset(
          'assets/images/hotel_im/hotel.jpg',
          width: double.infinity,
          height: 200,
          fit: BoxFit.cover,
        ),
        ],
      ),
      const SizedBox(height: 50),
      Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        DropdownButtonFormField<String>(
        decoration: const InputDecoration(
          labelText: 'Name of Hotel *',
        ),
        value: _selectedHotel,
        items: _hotels.map((hotel) {
          return DropdownMenuItem<String>(
            value: hotel,
            child: Text(hotel),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            _selectedHotel = value;
          });
        },
        validator: (value) {
          if (value == null) {
            return 'Please select a hotel';
          }
          return null;
        },
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
              controller: _numberOfChildren, // Changed controller
              decoration: const InputDecoration(
                labelText: 'Number of Children *', // Updated label
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the number of children';
                }
                if (int.tryParse(value) == null || int.parse(value)! <= 0) {
                  return 'Please enter a valid number';
                }
                return null;
              },
            ),
          ),
        ],
      ),
      const SizedBox(height: 16),
      DropdownButtonFormField<String>(
      decoration: const InputDecoration(
      labelText: 'Room Preference *',
    ),
    value: _selectedRoomPreference,
    items: ['Single', 'Double', 'Suite']
        .map((room) => DropdownMenuItem<String>(
    value: room,
    child: Text(room),
    ))
        .toList(),
    onChanged: (value) {
    setState(() {
    _selectedRoomPreference = value;
    });
    },
    validator: (value) {
    if (value == null) {
    return 'Please select a room preference';
    }
    return null;
    },
      ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Submit the form
                  // ...
                }
              },
              child: const Text('Book Now'),
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

