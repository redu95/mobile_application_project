import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyBookingsPage extends StatefulWidget {
  @override
  _MyBookingsPageState createState() => _MyBookingsPageState();
}

class _MyBookingsPageState extends State<MyBookingsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late String _userId;

  @override
  void initState() {
    super.initState();
    _userId = _auth.currentUser!.uid;
  }

  Future<void> _cancelBooking(String bookingId) async {
    try {
      await _firestore.collection('bookings').doc(bookingId).update({'status': 'Cancelled'});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Booking cancelled successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to cancel booking. Please try again later.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Bookings'),
        backgroundColor: Colors.purple,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('bookings')
            .where('user_id', isEqualTo: _userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No bookings found'));
          }

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: snapshot.data!.docs.map((document) {
              return FutureBuilder<DocumentSnapshot>(
                future: _getHotelData(document),
                builder: (context, hotelSnapshot) {
                  if (hotelSnapshot.connectionState == ConnectionState.waiting) {
                    return SizedBox(); // Placeholder widget while waiting for future to complete
                  }

                  if (!hotelSnapshot.hasData || hotelSnapshot.data!.data() == null) {
                    return SizedBox(); // Placeholder widget for missing data
                  }

                  Map<String, dynamic> booking = document.data() as Map<String, dynamic>;
                  Map<String, dynamic> hotelData = hotelSnapshot.data!.data() as Map<String, dynamic>;

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    elevation: 5,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hotel: ${hotelData['name']}',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.purple),
                          ),
                          const SizedBox(height: 10),
                          Text('Guest Name: ${booking['guest_name']}'),
                          const SizedBox(height: 5),
                          Text('Email: ${booking['guest_email']}'),
                          const SizedBox(height: 5),
                          Text('Phone: ${booking['guest_contact']}'),
                          const SizedBox(height: 5),
                          Text('Check-in Date: ${booking['check_in']['date']} at ${booking['check_in']['time']}'),
                          const SizedBox(height: 5),
                          Text('Check-out Date: ${booking['check_out']['date']} at ${booking['check_out']['time']}'),
                          const SizedBox(height: 5),
                          Text('Number of Adults: ${booking['number_of_adults']}'),
                          const SizedBox(height: 5),
                          Text('Number of Children: ${booking['number_of_children']}'),
                          const SizedBox(height: 5),
                          Text('Room Type: ${booking['room_type']}'),
                          const SizedBox(height: 5),
                          Text('Room Preference: ${booking['room_preference']}'),
                          const SizedBox(height: 5),
                          Text('Total Price: \$${booking['total_price']}'),
                          const SizedBox(height: 5),
                          Text('Status: ${booking['status']}'),
                          const SizedBox(height: 10),
                          booking['status'] == 'Cancelled'
                              ? ElevatedButton(
                            onPressed: null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey,
                            ),
                            child: Text('Booking Cancelled'),
                          )
                              : ElevatedButton(
                            onPressed: () => _cancelBooking(document.id),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple,
                            ),
                            child: Text('Cancel Booking'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }

  Future<DocumentSnapshot> _getHotelData(QueryDocumentSnapshot document) async {
    final hotelId = document['hotel_id'];
    return await _firestore.collection('hotels').doc(hotelId).get();
  }
}
