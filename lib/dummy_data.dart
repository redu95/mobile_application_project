import 'package:cloud_firestore/cloud_firestore.dart';

class PlaceListData{
  String imgPath;
  String title;
  String sub;
  double distance;
  double rating;
  int reviews;
  int perNight;

  PlaceListData({

    this.imgPath = '',
    this.title = "",
    this.sub = "",
    this.distance = 1,
    this.rating = 4,
    this.reviews = 100,
    this.perNight = 100,
  }
  );

  // static List<PlaceListData> list = [
  //   PlaceListData(
  //     imgPath: "assets/images/hotel_im/Capital.jpeg",
  //     title: "Capital Hotel",
  //     sub: "Addis Ababa, Ethiopia",
  //     distance: 2.0,
  //     rating: 4.4,
  //     reviews: 80,
  //     perNight: 180
  //   ),
  //   PlaceListData(
  //       imgPath: "assets/images/hotel_im/harmony.jpeg",
  //       title: "Harmony Hotel",
  //       sub: "Addis Ababa, Ethiopia",
  //       distance: 2.0,
  //       rating: 4.4,
  //       reviews: 80,
  //       perNight: 180
  //   ),
  //   PlaceListData(
  //       imgPath: "assets/images/hotel_im/Hilton.jpeg",
  //       title: "Hilton Hotel",
  //       sub: "Addis Ababa, Ethiopia",
  //       distance: 2.0,
  //       rating: 4.4,
  //       reviews: 80,
  //       perNight: 180
  //   ),
  //   PlaceListData(
  //       imgPath: "assets/images/hotel_im/sheraton.jpeg",
  //       title: "Sheraton Hotel",
  //       sub: "Addis Ababa, Ethiopia",
  //       distance: 2.0,
  //       rating: 4.4,
  //       reviews: 80,
  //       perNight: 180
  //   ),
  //   PlaceListData(
  //       imgPath: "assets/images/hotel_im/skycityb.jpg",
  //       title: "SkyCity Hotel",
  //       sub: "Addis Ababa, Ethiopia",
  //       distance: 2.0,
  //       rating: 4.4,
  //       reviews: 80,
  //       perNight: 180
  //   ),
  //   PlaceListData(
  //       imgPath: "assets/images/hotel_im/skylight.jpeg",
  //       title: "Skylight Hotel",
  //       sub: "Addis Ababa, Ethiopia",
  //       distance: 2.0,
  //       rating: 4.4,
  //       reviews: 80,
  //       perNight: 180
  //   ),
  //   PlaceListData(
  //       imgPath: "assets/images/hotel_im/capitalb.jpg",
  //       title: "Holiday Hotel",
  //       sub: "Addis Ababa, Ethiopia",
  //       distance: 2.0,
  //       rating: 4.4,
  //       reviews: 80,
  //       perNight: 180
  //   ),
  //   PlaceListData(
  //       imgPath: "assets/images/hotel_im/Ililib.jpeg",
  //       title: "Elile Hotel",
  //       sub: "Addis Ababa, Ethiopia",
  //       distance: 2.0,
  //       rating: 4.4,
  //       reviews: 80,
  //       perNight: 180
  //   ),
  // ];

  static Future<List<PlaceListData>> fetchHotels() async {
    List<PlaceListData> hotelList = [];
    try {
      QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('hotels').get();
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        // Constructing the location string from city, country, and address
        String location = "${data['location']['city']}, ${data['location']['country']}, ${data['location']['address']}";
        PlaceListData hotel = PlaceListData(
          title: data['name'] ?? '',
          sub: location,
          rating: data['rating']?.toDouble() ?? 0.0,
        );
        hotelList.add(hotel);
      });
    } catch (error) {
      print("Error fetching hotels: $error");
    }
    return hotelList;
  }
}