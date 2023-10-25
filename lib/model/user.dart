class User {
  final String email;
  final String username;
  final String? image;
  final String? bio;

  User({required this.email, required this.username, this.image, this.bio});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        email: json['email'],
        username: json['username'],
        image: json['imageUrl'],
        bio: json['bio']
    );
  }
}