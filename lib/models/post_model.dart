import 'package:flutter/foundation.dart';

class Post {
  final String id;
  final String title;
  final String? link;
  final String? desc;
  final String communityName;
  final String communityProfilePics;
  final List<String> upVotes;
  final List<String> downVotes;
  final int commentCount;
  final String username;
  final String uid;
  final String type;
  final DateTime createdAt;
  final List<String> awards;

  Post({
    required this.id,
    required this.title,
    this.link,
    this.desc,
    required this.communityName,
    required this.communityProfilePics,
    required this.upVotes,
    required this.downVotes,
    required this.commentCount,
    required this.username,
    required this.uid,
    required this.type,
    required this.createdAt,
    required this.awards,
  });

  Post copyWith({
    String? id,
    String? title,
    String? link,
    String? desc,
    String? communityName,
    String? communityProfilePics,
    List<String>? upVotes,
    List<String>? downVotes,
    int? commentCount,
    String? username,
    String? uid,
    String? type,
    DateTime? createdAt,
    List<String>? awards,
  }) {
    return Post(
      id: id ?? this.id,
      title: title ?? this.title,
      link: link ?? this.link,
      desc: desc ?? this.desc,
      communityName: communityName ?? this.communityName,
      communityProfilePics: communityProfilePics ?? this.communityProfilePics,
      upVotes: upVotes ?? this.upVotes,
      downVotes: downVotes ?? this.downVotes,
      commentCount: commentCount ?? this.commentCount,
      username: username ?? this.username,
      uid: uid ?? this.uid,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      awards: awards ?? this.awards,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'link': link,
      'desc': desc,
      'communityName': communityName,
      'communityProfilePics': communityProfilePics,
      'upVotes': upVotes,
      'downVotes': downVotes,
      'commentCount': commentCount,
      'username': username,
      'uid': uid,
      'type': type,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'awards': awards,
    };
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'] as String,
      title: map['title'] as String,
      link: map['link'] != null ? map['link'] as String : null,
      desc: map['desc'] != null ? map['desc'] as String : null,
      communityName: map['communityName'] as String,
      communityProfilePics: map['communityProfilePics'] as String,
      upVotes: List<String>.from(map['upVotes']),
      downVotes: List<String>.from(map['downVotes']),
      commentCount: map['commentCount'] as int,
      username: map['username'] as String,
      uid: map['uid'] as String,
      type: map['type'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      awards: List<String>.from(map['awards']),
    );
  }

  @override
  String toString() {
    return 'Post(id: $id, title: $title, link: $link, desc: $desc, communityName: $communityName, communityProfilePics: $communityProfilePics, upVotes: $upVotes, downVotes: $downVotes, commentCount: $commentCount, username: $username, uid: $uid, type: $type, createdAt: $createdAt, awards: $awards)';
  }

  @override
  bool operator ==(covariant Post other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.link == link &&
        other.desc == desc &&
        other.communityName == communityName &&
        other.communityProfilePics == communityProfilePics &&
        listEquals(other.upVotes, upVotes) &&
        listEquals(other.downVotes, downVotes) &&
        other.commentCount == commentCount &&
        other.username == username &&
        other.uid == uid &&
        other.type == type &&
        other.createdAt == createdAt &&
        listEquals(other.awards, awards);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        link.hashCode ^
        desc.hashCode ^
        communityName.hashCode ^
        communityProfilePics.hashCode ^
        upVotes.hashCode ^
        downVotes.hashCode ^
        commentCount.hashCode ^
        username.hashCode ^
        uid.hashCode ^
        type.hashCode ^
        createdAt.hashCode ^
        awards.hashCode;
  }
}
