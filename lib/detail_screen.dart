import 'package:flutter/material.dart';

import 'booking.dart';

class Detail extends StatelessWidget {
  final String imageurl;
  final String hotelName;
  final String hotelLocation;

  const Detail(this.imageurl, this.hotelName, this.hotelLocation, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text("\$106",style: TextStyle(fontSize: 40),
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
                  borderRadius:BorderRadius.circular(12),),
                color: const Color(0xff3C4657),
                child: const Text(
                  "Select room",style: TextStyle(fontSize:22,color: Colors.white ),
                ),

              ),

            )
          ],

        ),
      ) ,
      body:SafeArea(
      child:Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.3,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(imageurl),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(

              children: [

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: const Color(0xFFF8FCFF),
                        ),
                        width: 60,
                        child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.arrow_back_ios, size: 30, color: Colors.purple,),
                          iconSize: 30,
                        ),
                      ),
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: const Color(0xFFF8FCFF),

                        ),
                        width: 60,
                        child: const Icon(

                          Icons.favorite_border,size: 30, color: Colors.purple,),
                      ),


                    ],
                  ),
                )
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
                  "Our hotel  is a prestigious hotel in Addis Ababa, Ethiopia, offering luxurious accommodations, "
                      "exceptional amenities, and prime location. With elegant rooms, "
                      "exquisite dining, and extensive facilities, it guarantees a memorable stay.",
                style: TextStyle(fontSize:14 ),),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal:12.0,vertical: 10 ),
            child: Row(
              mainAxisAlignment:MainAxisAlignment.spaceBetween ,
              children: [
                Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 145, 233, 148),
                    borderRadius: BorderRadius.circular(12),

                  ),
                  child: const Icon(Icons.wifi,size: 40,),
                ),
                Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 158, 228, 221),
                    borderRadius: BorderRadius.circular(12),

                  ),
                  child: const Icon(Icons.ac_unit,size: 40,),
                )
                ,Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 245, 214, 167),
                    borderRadius: BorderRadius.circular(12),

                  ),
                  child: const Icon(Icons.restaurant,size: 40,),
                ),
                Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 145, 233, 148),
                    borderRadius: BorderRadius.circular(12),

                  ),
                  child: const Icon(Icons.car_rental,size: 40,),
                ),
                Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 114, 195, 233),
                    borderRadius: BorderRadius.circular(12),

                  ),
                  child: const Icon(Icons.pool,size: 40,),
                )
              ],
            ),
          ),

        ],
      ),
      ));
  }
}