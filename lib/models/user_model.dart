class User {
  final String name;
  final String img;

  User({required this.name, required this.img});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      img: json['img'],
    );
  }
}