class Comment {
  final String id;
  final String text;
  final DateTime createdAt;
  final String postId;
  final String username;
  final String profilePic;

  Comment({
    required this.id,
    required this.text,
    required this.createdAt,
    required this.postId,
    required this.username,
    required this.profilePic,
  });

  Comment copyWith({
    String? id,
    String? text,
    DateTime? createdAt,
    String? postId,
    String? username,
    String? profilePic,
  }) =>
      Comment(
        id: id ?? this.id,
        text: text ?? this.text,
        createdAt: createdAt ?? this.createdAt,
        postId: postId ?? this.postId,
        username: username ?? this.username,
        profilePic: profilePic ?? this.profilePic,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'id': id,
        'text': text,
        'createdAt': createdAt.millisecondsSinceEpoch,
        'postId': postId,
        'username': username,
        'profilePic': profilePic,
      };

  factory Comment.fromMap(Map<String, dynamic> map) => Comment(
        id: map['id'] as String,
        text: map['text'] as String,
        createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
        postId: map['postId'] as String,
        username: map['username'] as String,
        profilePic: map['profilePic'] as String,
      );
}
