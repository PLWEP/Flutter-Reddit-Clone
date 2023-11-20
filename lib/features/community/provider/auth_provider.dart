import 'package:flutter_reddit_clone/core/provider/firebase_provider.dart';
import 'package:flutter_reddit_clone/core/provider/storage_repository_provider.dart';
import 'package:flutter_reddit_clone/features/community/controller/community_controller.dart';
import 'package:flutter_reddit_clone/features/community/repository/community_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getCommunityByNameProvider = StreamProvider.family(
  (ref, String name) =>
      ref.watch(communityControllerProvider.notifier).getCommunityByName(name),
);

final userCommunitiesProvider = StreamProvider(
  (ref) => ref.watch(communityControllerProvider.notifier).getUserCommunities(),
);

final searchCommunitiesProvider = StreamProvider.family(
  (ref, String query) =>
      ref.watch(communityControllerProvider.notifier).searchCommunity(query),
);

final communityControllerProvider =
    StateNotifierProvider<CommunityController, bool>(
  (ref) {
    final communityRepository = ref.watch(communityRepositoryProvider);
    final storageRepository = ref.watch(storageRepositoryProvider);
    return CommunityController(
      ref: ref,
      communityRepository: communityRepository,
      storageRepository: storageRepository,
    );
  },
);

final getCommunityPostProvider = StreamProvider.family(
  (ref, String name) =>
      ref.read(communityControllerProvider.notifier).getCommunityPost(name),
);

final communityRepositoryProvider = Provider(
  (ref) => CommunityRepository(
    firestore: ref.watch(firestoreProvider),
  ),
);
