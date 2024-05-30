import 'package:cloud_firestore/cloud_firestore.dart';

class PlaceListData{
  String id;
  String imgPath;
  String title;
  String sub;
  double distance;
  double rating;
  int reviews;
  int perNight;

  PlaceListData({

    this.id = '',
    this.imgPath = '',
    this.title = "",
    this.sub = "",
    this.distance = 1,
    this.rating = 4,
    this.reviews = 100,
    this.perNight = 100,
  }
  );
  static Future<List<PlaceListData>> fetchHotels() async {
    List<PlaceListData> hotelList = [];
    try {
      QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('hotels').get();
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        // Constructing the location string from city, country, and address
        String location = "${data['location']['address']}, ${data['location']['city']}, ${data['location']['country']}";
        PlaceListData hotel = PlaceListData(
          id: data['id'],
          title: data['name'] ?? '',
          sub: location,
          rating: data['rating']?.toDouble() ?? 0.0,
          imgPath: data['imgUrl']
        );
        hotelList.add(hotel);
      });
    } catch (error) {
      print("Error fetching hotels: $error");
    }
    return hotelList;
  }
}