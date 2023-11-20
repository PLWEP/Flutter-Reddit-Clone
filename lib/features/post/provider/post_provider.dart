import 'package:flutter_reddit_clone/core/provider/firebase_provider.dart';
import 'package:flutter_reddit_clone/core/provider/storage_repository_provider.dart';
import 'package:flutter_reddit_clone/features/post/controller/post_controller.dart';
import 'package:flutter_reddit_clone/features/post/repository/post_repository.dart';
import 'package:flutter_reddit_clone/models/community_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userPostProvider = StreamProvider.family(
  (ref, List<Community> communities) {
    final postController = ref.watch(postControllerProvider.notifier);
    return postController.fetchUserPost(communities);
  },
);

final guestPostProvider = StreamProvider(
  (ref) {
    final postController = ref.watch(postControllerProvider.notifier);
    return postController.fetchGuestPost();
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

final postRepositoryProvider = Provider(
  (ref) => PostRepository(
    firestore: ref.watch(firestoreProvider),
  ),
);
