import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_reddit_clone/core/constant/firebase_constant.dart';
import 'package:flutter_reddit_clone/core/failure.dart';
import 'package:flutter_reddit_clone/core/type_def.dart';
import 'package:flutter_reddit_clone/models/community_model.dart';
import 'package:flutter_reddit_clone/models/post_model.dart';
import 'package:fpdart/fpdart.dart';

class CommunityRepository {
  final FirebaseFirestore _firestore;

  CommunityRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _communities =>
      _firestore.collection(FirebaseConstants.communitiesCollection);
  CollectionReference get _posts =>
      _firestore.collection(FirebaseConstants.postsCollection);

  FutureVoid createCommunity(Community community) async {
    try {
      var communityDoc = await _communities.doc(community.name).get();
      if (communityDoc.exists) {
        throw "Community ${community.name}already exists";
      }

      return right(_communities.doc(community.name).set(community.toMap()));
    } on FirebaseException catch (e) {
      return left(Failure(e.message!));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Community>> getUserCommunity(String uid) =>
      _communities.where('members', arrayContains: uid).snapshots().map(
        (event) {
          List<Community> communities = [];
          for (var doc in event.docs) {
            communities
                .add(Community.fromMap(doc.data() as Map<String, dynamic>));
          }
          return communities;
        },
      );

  Stream<Community> getCommunityByName(String name) =>
      _communities.doc(name).snapshots().map(
            (event) => Community.fromMap(event.data() as Map<String, dynamic>),
          );

  FutureVoid editComunity(Community community) async {
    try {
      return right(_communities.doc(community.name).update(community.toMap()));
    } on FirebaseException catch (e) {
      return left(Failure(e.message!));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Community>> searchCommunity(String query) => _communities
          .where(
            'name',
            isGreaterThanOrEqualTo: query.isEmpty ? 0 : query,
            isLessThan: query.isEmpty
                ? null
                : query.substring(0, query.length - 1) +
                    String.fromCharCode(query.codeUnitAt(query.length - 1) + 1),
          )
          .snapshots()
          .map(
        (event) {
          List<Community> communities = [];
          for (var commmunity in event.docs) {
            communities.add(
                Community.fromMap(commmunity.data() as Map<String, dynamic>));
          }
          return communities;
        },
      );

  FutureVoid joinCommunity(String communityName, String uid) async {
    try {
      return right(
        _communities.doc(communityName).update(
          {
            'members': FieldValue.arrayUnion([uid])
          },
        ),
      );
    } on FirebaseException catch (e) {
      return left(Failure(e.message!));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid leaveCommunity(String communityName, String uid) async {
    try {
      return right(
        _communities.doc(communityName).update(
          {
            'members': FieldValue.arrayRemove([uid])
          },
        ),
      );
    } on FirebaseException catch (e) {
      return left(Failure(e.message!));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid addMods(String communityName, List<String> uids) async {
    try {
      return right(
        _communities.doc(communityName).update(
          {'mods': uids},
        ),
      );
    } on FirebaseException catch (e) {
      return left(Failure(e.message!));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Post>> getCommunityPost(String name) => _posts
      .where('communityName', isEqualTo: name)
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map(
        (event) => event.docs
            .map((e) => Post.fromMap(e.data() as Map<String, dynamic>))
            .toList(),
      );
}
