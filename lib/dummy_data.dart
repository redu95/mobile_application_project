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

  static List<PlaceListData> list = [
    PlaceListData(
      imgPath: "assets/images/hotel_im/Capital.jpeg",
      title: "Capital Hotel",
      sub: "Addis Ababa, Ethiopia",
      distance: 2.0,
      rating: 4.4,
      reviews: 80,
      perNight: 180
    ),
    PlaceListData(
        imgPath: "assets/images/hotel_im/harmony.jpeg",
        title: "Harmony Hotel",
        sub: "Addis Ababa, Ethiopia",
        distance: 2.0,
        rating: 4.4,
        reviews: 80,
        perNight: 180
    ),
    PlaceListData(
        imgPath: "assets/images/hotel_im/Hilton.jpeg",
        title: "Hilton Hotel",
        sub: "Addis Ababa, Ethiopia",
        distance: 2.0,
        rating: 4.4,
        reviews: 80,
        perNight: 180
    ),
    PlaceListData(
        imgPath: "assets/images/hotel_im/sheraton.jpeg",
        title: "Sheraton Hotel",
        sub: "Addis Ababa, Ethiopia",
        distance: 2.0,
        rating: 4.4,
        reviews: 80,
        perNight: 180
    ),
    PlaceListData(
        imgPath: "assets/images/hotel_im/skycityb.jpg",
        title: "SkyCity Hotel",
        sub: "Addis Ababa, Ethiopia",
        distance: 2.0,
        rating: 4.4,
        reviews: 80,
        perNight: 180
    ),
    PlaceListData(
        imgPath: "assets/images/hotel_im/skylight.jpeg",
        title: "Skylight Hotel",
        sub: "Addis Ababa, Ethiopia",
        distance: 2.0,
        rating: 4.4,
        reviews: 80,
        perNight: 180
    ),
    PlaceListData(
        imgPath: "assets/images/hotel_im/capitalb.jpg",
        title: "Holiday Hotel",
        sub: "Addis Ababa, Ethiopia",
        distance: 2.0,
        rating: 4.4,
        reviews: 80,
        perNight: 180
    ),
    PlaceListData(
        imgPath: "assets/images/hotel_im/Ililib.jpeg",
        title: "Elile Hotel",
        sub: "Addis Ababa, Ethiopia",
        distance: 2.0,
        rating: 4.4,
        reviews: 80,
        perNight: 180
    ),
  ];
}