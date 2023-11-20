import 'package:flutter_reddit_clone/core/provider/firebase_provider.dart';
import 'package:flutter_reddit_clone/core/provider/storage_repository_provider.dart';
import 'package:flutter_reddit_clone/features/user%20profile/controller/user_profile_controller.dart';
import 'package:flutter_reddit_clone/features/user%20profile/repository/user_profile_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProfileRepositoryProvider = Provider(
  (ref) => UserProfileRepository(
    firestore: ref.watch(firestoreProvider),
  ),
);

final userProfileControllerProvider =
    StateNotifierProvider<UserProfileController, bool>(
  (ref) {
    final userProfileRepository = ref.watch(userProfileRepositoryProvider);
    final storageRepository = ref.watch(storageRepositoryProvider);
    return UserProfileController(
      ref: ref,
      userProfileRepository: userProfileRepository,
      storageRepository: storageRepository,
    );
  },
);

final getUserPostProvider = StreamProvider.family((ref, String uid) {
  return ref.read(userProfileControllerProvider.notifier).getUserPost(uid);
});
