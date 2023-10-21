class User {
  final String email;
  final String username;
  final String? image;

  User({required this.email, required this.username, this.image});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        email: json['email'],
        username: json['username'],
        image: json['image']
    );
  }
}