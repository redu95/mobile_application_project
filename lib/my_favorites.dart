import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'detail_screen.dart';

class MyFavorites extends StatefulWidget {
  const MyFavorites({super.key});

  @override
  State<MyFavorites> createState() => _MyFavoritesState();
}

class _MyFavoritesState extends State<MyFavorites> {

  List<Map<String, dynamic>> favoriteHotels = []; // To store fetched favorite hotel data
  late User user;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser!;
    fetchFavorites();
  }

  Future<void> fetchFavorites() async {
    try {
      // Fetch the favorite hotel IDs
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('favorites')
          .where('userId', isEqualTo: user.uid)
          .get();

      List<String> favoriteHotelIds = snapshot.docs.map((doc) => doc['hotelId'] as String).toList();

      // Fetch the hotel details for the favorite hotel IDs
      if (favoriteHotelIds.isNotEmpty) {
        QuerySnapshot hotelSnapshot = await FirebaseFirestore.instance
            .collection('hotels')
            .where(FieldPath.documentId, whereIn: favoriteHotelIds)
            .get();

        setState(() {
          favoriteHotels = hotelSnapshot.docs.map((doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            data['id'] = doc.id; // Add the document ID to the map
            return data;
          }).toList();
        });
      }
    } catch (e) {
      print("Error fetching the users favorites: $e");
    }
  }

  Future<void> addFavorite(String hotelId) async {
    try {
      await FirebaseFirestore.instance.collection('favorites').add({
        'userId': user.uid,
        'hotelId': hotelId,
        'createdAt': Timestamp.now(),
      });

      setState(() {
        fetchFavorites();
      });
    } catch (e) {
      print("Error adding favorite: $e");
    }
  }

  Future<void> removeFavorite(String hotelId) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('favorites')
          .where('userId', isEqualTo: user.uid)
          .where('hotelId', isEqualTo: hotelId)
          .get();

      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }

      setState(() {
        fetchFavorites();
      });
    } catch (e) {
      print("Error removing favorite: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Favorites'),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 4, vertical: 12),
        width: double.infinity,
        child: favoriteHotels.isEmpty
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: favoriteHotels.length,
          itemBuilder: (context, index) {
            var hotel = favoriteHotels[index];
            bool isFavorite = true; // Since these are all favorite hotels

            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Detail(hotelId: hotel['id']),
                  ),
                );
              },
              child: Container(
                height: 240,
                margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                width: 280,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.purpleAccent,
                    width: 1.5,
                  ),
                ),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                              ),
                              image: DecorationImage(
                                image: NetworkImage(hotel['imgUrl']),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                hotel['name'],
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    size: 20,
                                    color: Colors.black,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    hotel['location']['address'] + ', ' + hotel['location']['city'],
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Row(
                                    children: List.generate(
                                      5,
                                          (starIndex) =>
                                          Icon(
                                            Icons.star,
                                            color: Colors.purple,
                                            size: 20,
                                          ),
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    '${hotel['rating']} Reviews',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.purple,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      top: 250,
                      right: 8,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isFavorite = !isFavorite;
                          });
                          if (isFavorite) {
                            addFavorite(hotel['id']);
                          } else {
                            removeFavorite(hotel['id']);
                          }
                        },
                        child: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          size: 30,
                          color: isFavorite ? Colors.purple : Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
