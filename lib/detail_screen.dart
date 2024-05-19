import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Detail extends StatelessWidget {
  final String imageurl;
  final String hotelName;
  final String hotelLocation;

  Detail(this.imageurl, this.hotelName, this.hotelLocation);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text("\$106",style: TextStyle(fontSize: 40),
            ),
            Container(
              height: 60,
              child: MaterialButton(
                minWidth: 280,
                onPressed:(){},
                shape: RoundedRectangleBorder(
                  borderRadius:BorderRadius.circular(12),),
                color: Color(0xff3C4657),
                child: Text(
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
                          color: Color(0xFFF8FCFF),
                        ),
                        width: 60,
                        child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.arrow_back_ios, size: 30),
                          iconSize: 30,
                        ),
                      ),
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Color(0xfffF8FcFF),
                        ),
                        width: 60,
                        child: const Icon(
                          Icons.favorite_border,size: 30,),
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
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
                Row(
                  children: const [
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
                      style: TextStyle(fontSize: 24),
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
              children: const [
                Text(
                  "Detail",
                  style: TextStyle(fontSize: 22),
                ),
                Text(
                  "Hotel is a superior building meant for accommodation 15 or more strangers temporarily "
                      "for a few days. Strangers are changed according to the nature and period of accommodation. "
                      "Hotel provides both lodging (temporary habitation) & boarding facilities.",
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
                    color: Color.fromARGB(255, 145, 233, 148),
                    borderRadius: BorderRadius.circular(12),

                  ),
                  child: Icon(Icons.wifi,size: 40,),
                ),
                Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 158, 228, 221),
                    borderRadius: BorderRadius.circular(12),

                  ),
                  child: Icon(Icons.ac_unit,size: 40,),
                )
                ,Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 245, 214, 167),
                    borderRadius: BorderRadius.circular(12),

                  ),
                  child: Icon(Icons.restaurant,size: 40,),
                ),
                Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 145, 233, 148),
                    borderRadius: BorderRadius.circular(12),

                  ),
                  child: Icon(Icons.car_rental,size: 40,),
                ),
                Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 114, 195, 233),
                    borderRadius: BorderRadius.circular(12),

                  ),
                  child: Icon(Icons.pool,size: 40,),
                )
              ],
            ),
          ),

        ],
      ),
      ));
  }
}