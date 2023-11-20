import 'package:flutter_reddit_clone/core/provider/firebase_provider.dart';
import 'package:flutter_reddit_clone/core/provider/storage_repository_provider.dart';
import 'package:flutter_reddit_clone/features/post/controller/post_controller.dart';
import 'package:flutter_reddit_clone/features/post/repository/post_repository.dart';
import 'package:flutter_reddit_clone/models/community_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userPostProvider = StreamProvider.family(
  (ref, List<Community> communities) =>
      ref.watch(postControllerProvider.notifier).fetchUserPost(communities),
);

final guestPostProvider = StreamProvider(
  (ref) => ref.watch(postControllerProvider.notifier).fetchGuestPost(),
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

final getPostByIdProvider = StreamProvider.family(
  (ref, String postId) =>
      ref.watch(postControllerProvider.notifier).getPostById(postId),
);

final getPostCommentsProvider = StreamProvider.family(
  (ref, String postId) =>
      ref.watch(postControllerProvider.notifier).fetchPostComments(postId),
);

final postRepositoryProvider = Provider(
  (ref) => PostRepository(
    firestore: ref.watch(firestoreProvider),
  ),
);
