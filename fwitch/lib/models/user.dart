class User {
  final String uid;
  final String username;
  final String email;
  final String name;
  User({required this.uid, required this.username, required this.email,required this.name});

  Map<String, dynamic> toMap() {
    return {'uid': uid, 'username': username, 'email': email,'name':name};
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
        uid: map['uid'] ?? '',
        username: map['username'] ?? '',
        email: map['email'] ?? '',
        name: map['name']);
  }
}
