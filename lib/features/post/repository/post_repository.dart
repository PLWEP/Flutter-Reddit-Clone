import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_reddit_clone/core/constant/firebase_constant.dart';
import 'package:flutter_reddit_clone/core/failure.dart';
import 'package:flutter_reddit_clone/core/provider/firebase_provider.dart';
import 'package:flutter_reddit_clone/core/type_def.dart';
import 'package:flutter_reddit_clone/models/community_model.dart';
import 'package:flutter_reddit_clone/models/post_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final postRepositoryProvider = Provider(
  (ref) => PostRepository(
    firestore: ref.watch(firestoreProvider),
  ),
);

class PostRepository {
  final FirebaseFirestore _firestore;

  PostRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _posts =>
      _firestore.collection(FirebaseConstants.postsCollection);

  FutureVoid addPost(Post post) async {
    try {
      return right(_posts.doc(post.id).set(post.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Post>> fetchUserPost(List<Community> communities) {
    return _posts
        .where('communityName',
            whereIn: communities.map((e) => e.name).toList())
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (event) => event.docs
              .map((e) => Post.fromMap(e.data() as Map<String, dynamic>))
              .toList(),
        );
  }

  FutureVoid deletePost(Post post) async {
    try {
      return right(_posts.doc(post.id).delete());
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  void upvote(Post post, String userId) async {
    if (post.downVotes.contains(userId)) {
      _posts.doc(post.id).update({
        'downVotes': FieldValue.arrayRemove([userId]),
      });
    }

    if (post.upVotes.contains(userId)) {
      _posts.doc(post.id).update({
        'upVotes': FieldValue.arrayRemove([userId]),
      });
    } else {
      _posts.doc(post.id).update({
        'upVotes': FieldValue.arrayUnion([userId]),
      });
    }
  }

  void downvote(Post post, String userId) async {
    if (post.upVotes.contains(userId)) {
      _posts.doc(post.id).update({
        'upVotes': FieldValue.arrayRemove([userId]),
      });
    }

    if (post.downVotes.contains(userId)) {
      _posts.doc(post.id).update({
        'downVotes': FieldValue.arrayRemove([userId]),
      });
    } else {
      _posts.doc(post.id).update({
        'downVotes': FieldValue.arrayUnion([userId]),
      });
    }
  }
}
