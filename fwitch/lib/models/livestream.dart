class LiveStream {
  final String title;
  final String image;
  final String uid;
  final String username;
  final startedAt;
  final int viewers;
  final String channelId;

  LiveStream(
      {required this.title,
      required this.image,
      required this.uid,
      required this.username,
      required this.startedAt,
      required this.viewers,
      required this.channelId});

  factory LiveStream.fromJson(Map<String, dynamic> json) => LiveStream(
        title: json["title"],
        image: json["image"],
        uid: json["uid"],
        username: json["username"],
        startedAt: json["startedAt"],
        viewers: json["viewers"],
        channelId: json["channelId"],
      );

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'image': image,
      'uid': uid,
      'username': username,
      'startedAt': startedAt,
      'viewers': viewers,
      'channelId': channelId
    };
  }

  factory LiveStream.fromMap(Map<String, dynamic> map) {
    return LiveStream(
        title: map['title'] ?? '',
        image: map['image'] ?? '',
        uid: map['uid'] ?? '',
        username: map['username'] ?? '',
        startedAt: map['startedAt'] ?? '',
        viewers: map['viewers']?.toInt() ?? 0,
        channelId: map['channelId'] ?? '');
  }
}
