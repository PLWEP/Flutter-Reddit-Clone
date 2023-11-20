class UserModel {
  final String name;
  final String profilePic;
  final String banner;
  final String uid;
  final int karma;
  final List<String> awards;

  UserModel({
    required this.name,
    required this.profilePic,
    required this.banner,
    required this.uid,
    required this.karma,
    required this.awards,
  });

  UserModel copyWith({
    String? name,
    String? profilePic,
    String? banner,
    String? uid,
    bool? isAuthenticated,
    int? karma,
    List<String>? awards,
  }) =>
      UserModel(
        name: name ?? this.name,
        profilePic: profilePic ?? this.profilePic,
        banner: banner ?? this.banner,
        uid: uid ?? this.uid,
        karma: karma ?? this.karma,
        awards: awards ?? this.awards,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'name': name,
        'profilePic': profilePic,
        'banner': banner,
        'uid': uid,
        'karma': karma,
        'awards': awards,
      };

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
        name: map['name'] as String,
        profilePic: map['profilePic'] as String,
        banner: map['banner'] as String,
        uid: map['uid'] as String,
        karma: map['karma'] as int,
        awards: List<String>.from(map['awards']),
      );
}
