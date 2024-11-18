class Restaurant {
  final String name;
  final String img;
  final String restaurantLocation;

  Restaurant({
    required this.name,
    required this.img,
    required this.restaurantLocation,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      name: json['name'],
      img: json['img'],
      restaurantLocation: json['restaurantLocation'],
    );
  }
}