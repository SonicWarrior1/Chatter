class MyUser {
  final String uid;
  final String username;
  final String email;
  final String name;
  MyUser(
      {required this.uid,
      required this.username,
      required this.email,
      required this.name});

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': username,
      'email': email,
      'name': name,
    };
  }

  factory MyUser.fromMap(Map<String, dynamic> map) {
    return MyUser(
        uid: map['uid'] ?? '',
        username: map['username'] ?? '',
        email: map['email'] ?? '',
        name: map['name'] ?? '');
  }
}
