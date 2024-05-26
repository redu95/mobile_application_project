import 'package:flutter/material.dart';

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
  final _checkInTimeController = TextEditingController();
  final _checkOutDateController = TextEditingController();
  final _checkOutTimeController = TextEditingController();
  DateTime? _selectedCheckInDate;
  TimeOfDay? _selectedCheckInTime;
  DateTime? _selectedCheckOutDate;
  TimeOfDay? _selectedCheckOutTime;
  int? _selectedAdults;
  String? _selectedRoomPreference;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _checkInDateController.dispose();
    _checkInTimeController.dispose();
    _checkOutDateController.dispose();
    _checkOutTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            Stack(
            children: [
            Image.asset(
              'assets/images/hotel_im/skycityb.jpg',
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
              Positioned(
                bottom: 10,
                left: 10,
                child: Text(
                  'Addis stay',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    backgroundColor: Colors.black54,
                  ),
                ),
              ),
            ],
            ),
                const SizedBox(height: 50),
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
                            _checkInDateController.text =
                                _selectedCheckInDate!.toString();
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
                            _checkInTimeController.text =
                                _selectedCheckInTime!.format(context);
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
                            _checkOutDateController.text =
                                _selectedCheckOutDate!.toString();
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
                            _checkOutTimeController.text =
                                _selectedCheckOutTime!.format(context);
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text('Room Preference *'),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Radio<String>(
                      value: 'Single',
                      groupValue: _selectedRoomPreference,
                      onChanged: (value) {
                        setState(() {
                          _selectedRoomPreference = value;
                        });
                      },
                    ),
                    const Text('Single'),
                    const SizedBox(width: 16),
                    Radio<String>(
                      value: 'Double',
                      groupValue: _selectedRoomPreference,
                      onChanged: (value) {
                        setState(() {
                          _selectedRoomPreference = value;
                        });
                      },
                    ),
                    const Text('Double'),
                    const SizedBox(width: 16),
                    Radio<String>(
                      value: 'Suite',
                      groupValue: _selectedRoomPreference,
                      onChanged: (value) {
                        setState(() {
                          _selectedRoomPreference = value;
                        });
                      },
                    ),
                    const Text('Suite'),
                  ],
                ),
                const SizedBox(height: 16),
                const Text('Number of adults *'),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Radio<int>(
                      value: 1,
                      groupValue: _selectedAdults,
                      onChanged: (value) {
                        setState(() {
                          _selectedAdults = value;
                        });
                      },
                    ),
                    const Text('1'),
                    const SizedBox(width: 16),
                    Radio<int>(
                      value: 2,
                      groupValue: _selectedAdults,
                      onChanged: (value) {
                        setState(() {
                          _selectedAdults = value;
                        });
                      },
                    ),
                    const Text('2'),
                    const SizedBox(width: 16),
                    Radio<int>(
                      value: 3,
                      groupValue: _selectedAdults,
                      onChanged: (value) {
                        setState(() {
                          _selectedAdults = value;
                        });
                      },
                    ),
                    const Text('3'),
                    const SizedBox(width: 16),
                    Radio<int>(
                      value: 4,
                      groupValue: _selectedAdults,
                      onChanged: (value) {
                        setState(() {
                          _selectedAdults = value;
                        });
                      },
                    ),
                    const Text('4'),
                  ],
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
        ),
      ),
    );
  }
}