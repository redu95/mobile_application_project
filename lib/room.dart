class Room {
  String name;
  double price;
  String image;

  Room({required this.name, required this.price, required this.image});
}

class Hotel {
  String name;
  String classification;
  List<Room> rooms;

  Hotel({required this.name, required this.classification, required this.rooms});
}

void main() {
  // Create room objects
  Room room1 = Room(
    name: "Standard King Room",
    price: 100,
    image: "assets/images/standard_king_room.jpg",
  );

  Room room2 = Room(
    name: "Twin Room",
    price: 120,
    image: "assets/images/twin_room.jpg",
  );

  Room room3 = Room(
    name: "Superior King Room",
    price: 150,
    image: "assets/images/superior_king_room.jpg",
  );

  Room room4 = Room(
    name: "Suite",
    price: 200,
    image: "assets/images/suite_room.jpg",
  );

  Room room5 = Room(
    name: "Studio",
    price: 180,
    image: "assets/images/studio_room.jpg",
  );

  // Create hotel objects
  Hotel hotel1 = Hotel(
    name: "Hilton Hotel",
    classification: "3-star",
    rooms: [room1, room2, room3, room4, room5],
  );

  Hotel hotel2 = Hotel(
    name: "sheraton Hotel",
    classification: "4-star",
    rooms: [room1, room2, room3, room4, room5],
  );

  Hotel hotel3 = Hotel(
    name: "skylight Hotel",
    classification: "5-star",
    rooms: [room1, room2, room3, room4, room5],
  );

  Hotel hotel4 = Hotel(
    name: "Capital Hotel",
    classification: "3-star",
    rooms: [room1, room2, room3, room4, room5],
  );

  Hotel hotel5 = Hotel(
    name: "Harmony Hotel",
    classification: "4-star",
    rooms: [room1, room2, room3, room4, room5],
  );

  Hotel hotel6 = Hotel(
    name: "Sky city Hotel",
    classification: "5-star",
    rooms: [room1, room2, room3, room4, room5],
  );

  // Access hotel and room information
  print("Hotel Name: ${hotel1.name}");
  print("Hotel Classification: ${hotel1.classification}");
  print("Rooms:");
  for (Room room in hotel1.rooms) {
    print(" - ${room.name}: \$${room.price}");
    print("   Image: ${room.image}");
  }
}