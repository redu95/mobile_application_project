import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_application_project/colors.dart';

import 'booking.dart';

class Detail extends StatelessWidget {
  final String hotelId; // This will be the document ID of the hotel in Firestore

  const Detail({required this.hotelId});

  Future<Map<String, dynamic>> _fetchHotelDetails() async {
    DocumentSnapshot documentSnapshot =
    await FirebaseFirestore.instance.collection('hotels').doc(hotelId).get();
    Map<String, dynamic> hotelData = documentSnapshot.data() as Map<String, dynamic>;

    // Fetch room types
    QuerySnapshot roomTypesSnapshot = await documentSnapshot.reference.collection('room_types').get();
    List<Map<String, dynamic>> roomTypes = roomTypesSnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

    // Fetch reviews
    QuerySnapshot reviewsSnapshot = await documentSnapshot.reference.collection('reviews').get();
    List<Map<String, dynamic>> reviews = reviewsSnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

    hotelData['roomTypes'] = roomTypes;
    hotelData['reviews'] = reviews;

    return hotelData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>>(
        future: _fetchHotelDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No data found.'));
          } else {
            Map<String, dynamic> hotelData = snapshot.data!;
            List<String> imageUrls = hotelData['images'] != null ? List<String>.from(hotelData['images']) : [];
            String mainImageUrl = hotelData['imgUrl'] ?? ''; // Add a default empty string if null
            if (mainImageUrl.isNotEmpty) {
              imageUrls.insert(0, mainImageUrl);
            }

            return SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: imageUrls.map((imageUrl) => _buildImageContainer(imageUrl, context)).toList(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          hotelData['name'] ?? 'No name', // Add a default value if null
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            //color: Colors.black,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(Icons.location_on, size: 30,color: primaryColor,),
                            Text(
                              '${hotelData['location']?['address'] ?? 'No Address'}, ${hotelData['location']?['city'] ?? 'No city'}}',
                              style: const TextStyle(fontSize: 24),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Detail",
                          style: TextStyle(fontSize: 22),
                        ),
                        Text(
                          hotelData['description'] ?? 'No description', // Add a default value if null
                          style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Policies",
                          style: TextStyle(fontSize: 22),
                        ),
                        Text(
                          'Check-in: ${hotelData['policies']?['checkIn'] ?? 'No check-in info'}',
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          'Check-out: ${hotelData['policies']?['checkOut'] ?? 'No check-out info'}',
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          'Cancellation: ${hotelData['policies']?['cancellation'] ?? 'No cancellation info'}',
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          "Amenities",
                          style: TextStyle(fontSize: 22),
                        ),
                        ...?hotelData['amenities']?.map<Widget>((amenity) => Text(
                          amenity,
                          style: TextStyle(fontSize: 14),
                        )),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Reviews",
                          style: TextStyle(fontSize: 22),
                        ),
                        ...?hotelData['reviews']?.map<Widget>((review) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0,vertical: 4.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Rating: ${review['rating'] ?? 'No rating'}',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                review['comment'] ?? 'No comment',
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        )),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 0, vertical: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        Text(
                          "Our Rooms",
                          style: TextStyle(fontSize: 22),
                        ),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
                      child: Row(
                        children: List.generate(hotelData['roomTypes']?.length ?? 0, (index) {
                          var roomType = hotelData['roomTypes']?[index];
                          if (roomType != null) {
                            return _buildRoomBox(
                              context,
                              roomType['imgUrl'] ?? '', // Add a default empty string if null
                              hotelId,
                              roomType['type'] ?? 'No type', // Add a default value if null
                              roomType['pricePerNight'] ?? 0, // Add a default value if null
                              hotelData['name'],
                              // Add a default empty list if null
                            );
                          } else {
                            // Return a placeholder widget or handle the null case as per your requirement
                            return SizedBox();
                          }
                        }),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildImageContainer(String imageUrl, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      child: Stack(
        children: [
          Image.network(
            imageUrl,
            fit: BoxFit.cover,
          ),
          Positioned(
            top: 10,
            left: 10,
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                //color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  size: 20,
                  color: Colors.purple,
                ),
              ),
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                // color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.favorite_border,
                  size: 20,
                  color: Colors.purple,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoomBox(BuildContext context, String imageUrl,String hotelId, String roomType, int pricePerNight, String hotelName) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Container(
        width: 290,
        height: 350,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          //color: Colors.grey[200],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 250,
                ),
                Positioned(
                  bottom: 1,
                  right: 8,
                  child: SizedBox(
                    width: 100,
                    child: MaterialButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookingDemo(
                              hotelId:hotelId,
                              hotelName: hotelName,
                              roomName: roomType,
                              roomPrice: pricePerNight,
                              imageUrl: imageUrl,
                            ),
                          ),
                        );
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      color: accentColor,
                      child: const Text(
                        "Book Now",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Room Type: $roomType',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Price: \ETB${pricePerNight.toString()}',
                    style: const TextStyle(fontSize: 16),
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
