import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mobile_application_project/dummy_data.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'colors.dart';
import 'detail_screen.dart';

class PlacesWidget extends StatelessWidget {
  final PlaceListData? item;
  final Animation<double>? animation;
  final AnimationController? animationController;
  const PlacesWidget({ Key? key , this.item, this.animation, this.animationController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: animationController!,

        builder: (context, child) {
          return FadeTransition(
            opacity: animation!,

            child: Transform(
              transform: Matrix4.translationValues(0, 50 * (1 - animation!.value), 0),
              child:GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Detail(hotelId:item!.id),
                    ),
                  );
                },
                child: Container(
                    color: white,
                    padding: EdgeInsets.only(left: 25, right: 25, top:8, bottom: 16),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.6),
                                offset: Offset(4,4),
                                blurRadius: 16
                            )
                          ]
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          child: Column(
                            children: [
                              AspectRatio(
                                aspectRatio: 2,
                                child: Image.network(
                                  item!.imgPath,
                                  fit: BoxFit.cover,
                                ),
                              ),

                              Container(
                                color: white,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.only(left: 16, bottom: 8, top: 8),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(item!.title,
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 22
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Icon(
                                                  FontAwesomeIcons.locationDot,
                                                  size: 13,
                                                  color: purple,
                                                ),
                                                SizedBox(width: 5,),
                                                Text(item!.sub, style: TextStyle(
                                                    color: Colors.black.withOpacity(0.4),
                                                    fontSize: 14
                                                ),),
                                              ],
                                            ),

                                            Container(
                                              padding: EdgeInsets.only(top: 5),
                                              child: Row(
                                                  children: [
                                                    RatingBar(
                                                        initialRating: item!.rating,
                                                        direction: Axis.horizontal,
                                                        allowHalfRating: true,
                                                        itemCount: 5,
                                                        itemSize: 24,
                                                        ratingWidget: RatingWidget(
                                                            full: Icon(Icons.star_rate_rounded, color: purple,),
                                                            half: Icon(Icons.star_half_rounded, color: purple,),
                                                            empty: Icon(Icons.star_border_rounded, color: purple,)
                                                        ),
                                                        itemPadding: EdgeInsets.zero,
                                                        onRatingUpdate: (value) {

                                                        }
                                                    ),
                                                    Text("${item!.reviews} Reviews",
                                                      style: TextStyle(
                                                          color: Colors.black.withOpacity(0.4),
                                                          fontSize: 14
                                                      ),)
                                                  ]
                                              ),
                                            )

                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10,),
                                    Container(
                                        padding: EdgeInsets.only(right: 16, top: 8),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Icon(Ionicons.heart_outline)
                                          ],)
                                    )


                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                ),
              ),

            ),
          );
        }
    );
  }
}
