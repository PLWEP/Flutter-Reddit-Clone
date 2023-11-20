import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_reddit_clone/core/enums.dart';
import 'package:flutter_reddit_clone/core/provider/storage_repository_provider.dart';
import 'package:flutter_reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:flutter_reddit_clone/features/post/repository/post_repository.dart';
import 'package:flutter_reddit_clone/features/user%20profle/controller/user_profile_controller.dart';
import 'package:flutter_reddit_clone/models/comment_model.dart';
import 'package:flutter_reddit_clone/models/community_model.dart';
import 'package:flutter_reddit_clone/models/post_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_reddit_clone/core/utils.dart';

final userPostProvider = StreamProvider.family(
  (ref, List<Community> communities) {
    final postController = ref.watch(postControllerProvider.notifier);
    return postController.fetchUserPost(communities);
  },
);

final postControllerProvider = StateNotifierProvider<PostController, bool>(
  (ref) {
    final postRepository = ref.watch(postRepositoryProvider);
    final storageRepository = ref.watch(storageRepositoryProvider);
    return PostController(
      ref: ref,
      postRepository: postRepository,
      storageRepository: storageRepository,
    );
  },
);

final getPostByIdProvider = StreamProvider.family((ref, String postId) {
  final postController = ref.watch(postControllerProvider.notifier);
  return postController.getPostById(postId);
});

final getPostCommentsProvider = StreamProvider.family((ref, String postId) {
  final postController = ref.watch(postControllerProvider.notifier);
  return postController.fetchPostComments(postId);
});

class PostController extends StateNotifier<bool> {
  final PostRepository _postRepository;
  final Ref _ref;
  final StorageRepositorty _storageRepository;

  PostController(
      {required PostRepository postRepository,
      required Ref ref,
      required StorageRepositorty storageRepository})
      : _postRepository = postRepository,
        _storageRepository = storageRepository,
        _ref = ref,
        super(false);

  void shareTextPost({
    required BuildContext context,
    required String title,
    required Community selectedCommunity,
    required String description,
  }) async {
    state = true;
    String postId = const Uuid().v1();
    final user = _ref.read(userProvider)!;

    final Post post = Post(
      id: postId,
      title: title,
      communityName: selectedCommunity.name,
      communityProfilePics: selectedCommunity.avatar,
      upVotes: [],
      downVotes: [],
      commentCount: 0,
      username: user.name,
      uid: user.uid,
      type: 'text',
      createdAt: DateTime.now(),
      awards: [],
      desc: description,
    );

    final res = await _postRepository.addPost(post);
    _ref
        .read(userProfileControllerProvider.notifier)
        .updateUserKarma(UserKarma.textPost);
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        showSnackBar(context, "Posted  successfully");
        Routemaster.of(context).pop();
      },
    );
  }

  void shareLinkPost({
    required BuildContext context,
    required String title,
    required Community selectedCommunity,
    required String link,
  }) async {
    state = true;
    String postId = const Uuid().v1();
    final user = _ref.read(userProvider)!;

    final Post post = Post(
      id: postId,
      title: title,
      communityName: selectedCommunity.name,
      communityProfilePics: selectedCommunity.avatar,
      upVotes: [],
      downVotes: [],
      commentCount: 0,
      username: user.name,
      uid: user.uid,
      type: 'link',
      createdAt: DateTime.now(),
      awards: [],
      link: link,
    );

    final res = await _postRepository.addPost(post);
    _ref
        .read(userProfileControllerProvider.notifier)
        .updateUserKarma(UserKarma.linkPost);
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        showSnackBar(context, "Posted  successfully");
        Routemaster.of(context).pop();
      },
    );
  }

  void shareImagePost({
    required BuildContext context,
    required String title,
    required Community selectedCommunity,
    required File? file,
  }) async {
    state = true;
    String postId = const Uuid().v1();
    final user = _ref.read(userProvider)!;
    final imageRes = await _storageRepository.storeFile(
      path: 'post/${selectedCommunity.name}',
      id: postId,
      file: file,
    );

    imageRes.fold(
      (l) => showSnackBar(context, l.message),
      (r) async {
        final Post post = Post(
          id: postId,
          title: title,
          communityName: selectedCommunity.name,
          communityProfilePics: selectedCommunity.avatar,
          upVotes: [],
          downVotes: [],
          commentCount: 0,
          username: user.name,
          uid: user.uid,
          type: 'image',
          createdAt: DateTime.now(),
          awards: [],
          link: r,
        );

        final res = await _postRepository.addPost(post);
        _ref
            .read(userProfileControllerProvider.notifier)
            .updateUserKarma(UserKarma.imagePost);
        state = false;
        res.fold(
          (l) => showSnackBar(context, l.message),
          (r) {
            showSnackBar(context, "Posted  successfully");
            Routemaster.of(context).pop();
          },
        );
      },
    );
  }

  Stream<List<Post>> fetchUserPost(List<Community> communities) {
    if (communities.isNotEmpty) {
      return _postRepository.fetchUserPost(communities);
    }

    return Stream.value([]);
  }

  void deletePost(BuildContext context, Post post) async {
    final res = await _postRepository.deletePost(post);
    _ref
        .read(userProfileControllerProvider.notifier)
        .updateUserKarma(UserKarma.deletePost);
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) => showSnackBar(context, "Delete post  successfully"),
    );
  }

  void upvote(Post post) async {
    final user = _ref.read(userProvider)!;
    _postRepository.upvote(post, user.uid);
  }

  void downvote(Post post) async {
    final user = _ref.read(userProvider)!;
    _postRepository.downvote(post, user.uid);
  }

  Stream<Post> getPostById(String postId) {
    return _postRepository.getPostById(postId);
  }

  void addComment({
    required BuildContext context,
    required String text,
    required Post post,
  }) async {
    String commentId = const Uuid().v1();
    final user = _ref.read(userProvider)!;
    final comment = Comment(
      id: commentId,
      text: text,
      createdAt: DateTime.now(),
      postId: post.id,
      username: user.name,
      profilePic: user.profilePic,
    );
    final res = await _postRepository.addComment(comment);
    _ref
        .read(userProfileControllerProvider.notifier)
        .updateUserKarma(UserKarma.comment);
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) => null,
    );
  }

  Stream<List<Comment>> fetchPostComments(String postId) {
    return _postRepository.getCommentsOfPost(postId);
  }
}
