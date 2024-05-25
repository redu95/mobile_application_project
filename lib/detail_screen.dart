import 'package:flutter/material.dart';

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
      this.hotelLocation, );

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
                onPressed: () {},
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: const Color(0xff3C4657),
                child: const Text(
                  "Book Now",
                  style: TextStyle(fontSize: 22, color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Image.asset(
                      imageurl1,
                      fit: BoxFit.cover,
                    ),
                    Image.asset(
                      imageurl2,
                      fit: BoxFit.cover,
                    ),
                    Image.asset(
                      imageurl3,
                      fit: BoxFit.cover,
                    ),
                  ],
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
                    const Row(
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
                        const Icon(Icons.location_on, size: 30),
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
                      "Our hotel is a prestigious hotel in Addis Ababa, Ethiopia, offering luxurious accommodations, exceptional amenities, and a prime location. With elegant rooms, exquisite dining, and extensive facilities, it guarantees a memorable stay.",
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
                  child: Wrap(
                    spacing: 40.0, // Increased spacing between icons
                    runSpacing: 10.0,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 10.0), // Add left margin to the first icon
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 145, 233, 148),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.wifi,
                          size: 40,
                        ),
                      ),
                      Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 158, 228, 221),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.ac_unit,
                          size: 40,
                        ),
                      ),
                      Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 245, 214, 167),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.restaurant,
                          size: 40,
                        ),
                      ),
                      Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 145, 233, 148),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.car_rental,
                          size: 40,
                        ),
                      ),
                      Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 114, 195, 233),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.pool,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}