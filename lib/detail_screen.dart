import 'package:flutter/material.dart';
import 'booking.dart';

class Detail extends StatelessWidget {
  final String imageurl1;
  final String imageurl2;
  final String imageurl3;
  final String room1name;
  final String room1price;
  final String room1img;
  final String room2name;
  final String room2price;
  final String room2img;
  final String room3name;
  final String room3price;
  final String room3img;
  final String room4name;
  final String room4price;
  final String room4img;
  final String room5name;
  final String room5price;
  final String room5img;
  final String room6name;
  final String room6price;
  final String room6img;
  final String room7name;
  final String room7price;
  final String room7img;

  final String review;
  final String hotelName;
  final String hotelLocation;

  const Detail(
      this.imageurl1,
      this.imageurl2,
      this.imageurl3,
      this.review,
      this.room1img,
      this.room1name,
      this.room1price,
      this.room2img,
      this.room2name,
      this.room2price,
      this.room3img,
      this.room3name,
      this.room3price,
      this.room4img,
      this.room4name,
      this.room4price,
      this.room5img,
      this.room5name,
      this.room5price,
      this.room6img,
      this.room6name,
      this.room6price,
      this.room7img,
      this.room7name,
      this.room7price,
      this.hotelName,
      this.hotelLocation,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 10),
                      child: Stack(
                        children: [
                          Image.asset(
                            imageurl1,
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            top: 10,
                            left: 10,
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                color: Colors.white,
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
                                color: Colors.white,
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
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 10),
                      child: Image.asset(
                        imageurl2,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 10),
                      child: Image.asset(
                        imageurl3,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hotelName,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 30),
                      Text(
                        hotelLocation,
                        style: const TextStyle(fontSize: 24),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Detail",
                    style: TextStyle(fontSize: 22),
                  ),
                  Text(
                    "Welcome to our luxurious hotel! Located in the heart of the city, our hotel offers a comfortable and elegant stay for both business and leisure travelers. With our world-class amenities and exceptional service, we strive to make your stay truly memorable.",
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
                child: Row(
                  children: [
                    SizedBox(
                      width: 140,
                      child: _buildIconBox(
                        Icons.wifi,
                        "Free WiFi",
                        const Color.fromARGB(255, 145, 233, 148),
                      ),
                    ),
                    SizedBox(width: 40),
                    SizedBox(
                      width: 140,
                      child: _buildIconBox(
                        Icons.ac_unit,
                        "Air Conditioning",
                        const Color.fromARGB(255, 158, 228, 221),
                      ),
                    ),
                    SizedBox(width: 40),
                    SizedBox(
                      width: 140,
                      child: _buildIconBox(
                        Icons.restaurant,
                        "Restaurant",
                        const Color.fromARGB(255, 245, 214, 167),
                      ),
                    ),
                    SizedBox(width: 40),
                    SizedBox(
                      width: 140,
                      child: _buildIconBox(
                        Icons.car_rental,
                        "Car Rental",
                        const Color.fromARGB(255, 145, 233, 148),
                      ),
                    ),
                    SizedBox(width: 40),
                    SizedBox(
                      width: 140,
                      child: _buildIconBox(
                        Icons.pool,
                        "Swimming Pool",
                        const Color.fromARGB(255, 114, 195, 233),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
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
                  children: [
                    _buildRoomBox(context, room1img, room1name, room1price),
                    SizedBox(width: 20),
                    _buildRoomBox(context, room2img, room2name, room2price),
                    SizedBox(width: 20),
                    _buildRoomBox(context, room3img, room3name, room3price),
                    SizedBox(width: 20),
                    _buildRoomBox(context, room4img, room4name, room4price),
                    SizedBox(width: 20),
                    _buildRoomBox(context, room5img, room5name, room5price),
                    SizedBox(width: 20),
                    _buildRoomBox(context, room5img, room5name, room5price),
                    SizedBox(width: 20),
                    _buildRoomBox(context, room5img, room5name, room5price),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Additional Information',
                    style: TextStyle(fontSize: 22),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Our hotel features a state-of-the-art fitness center, relaxing spa, and a rooftop swimming pool with stunning city views. Guests can indulge in a variety of dining options at our on-site restaurants, serving a wide range of international cuisines.',
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'We are conveniently located near major attractions and shopping centers, making it easy for you to explore the city and enjoy your leisure time. Our dedicated and friendly staff is available 24/7 to assist you with any requests or inquiries you may have.',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),



            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.phone, size: 40),
                      const SizedBox(width: 10),
                      Text(
                        "+1 123-456-7890",
                        style: const TextStyle(fontSize: 24),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

    );
  }

  Widget _buildIconBox(IconData icon, String text, Color color) {
    return Container(
      margin: const EdgeInsets.only(right: 10.0),
      height: 80,
      width: 100,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
              color: Colors.white,
            ),
            const SizedBox(height: 6),
            Flexible(
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoomBox(BuildContext context, String image, String roomName, String roomPrice) {
    return Container(
      width: 290, // Increased width to accommodate larger image
      height: 350, // Increased height to accommodate larger image and room details
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[200],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Image.asset(
                image,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 250, // Increased height of the image
              ),
              Positioned(
                bottom: 1, // Adjusted position
                right: 8, // Adjusted position
                child: SizedBox(
                  width: 100,
                  child: MaterialButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const BookingDemo()),
                      );
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color: Colors.purpleAccent,
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
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 0), // Adjusted padding
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Room Type: $roomName',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  'Room Price: \$$roomPrice', // Added dollar sign before room price
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
