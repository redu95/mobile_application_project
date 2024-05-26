import 'package:flutter/material.dart';

import 'booking.dart';

class Detail extends StatelessWidget {
  final String imageurl1;
  final String imageurl2;
  final String imageurl3;
  final String hotelName;
  final String hotelLocation;

  const Detail(
      this.imageurl1,
      this.imageurl2,
      this.imageurl3,
      this.hotelName,
      this.hotelLocation,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text(
              "\$106",
              style: TextStyle(fontSize: 40),
            ),
            SizedBox(
              height: 60,
              child: MaterialButton(
                minWidth: 280,
                onPressed:(){
                    {
                      Navigator.push(
                        context, MaterialPageRoute(builder: (context) => const BookingDemo()),//redirect to booking form
                      );
                    };
                },

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: const Color(0xff3C4657),
                child: const Text(
                  "Book Now",
                  style: TextStyle(fontSize: 22, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
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
                        Icon(
                          Icons.star,
                          color: Colors.yellow,
                          size: 30,
                        ),
                        Icon(
                          Icons.star,
                          color: Colors.yellow,
                          size: 30,
                        ),
                        Icon(
                          Icons.star,
                          color: Colors.yellow,
                          size: 30,
                        ),
                        Icon(
                          Icons.star,
                          color: Colors.yellow,
                          size: 30,
                        ),
                        Icon(
                          Icons.star,
                          color: Colors.yellow,
                          size: 30,
                        ),
                      ],
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
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        Icon(Icons.phone, size: 30),
                        Text(
                          "+1 123-456-7890",
                          style: const TextStyle(fontSize: 24),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
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
}