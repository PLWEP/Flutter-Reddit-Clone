import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_reddit_clone/core/constant/constant.dart';
import 'package:flutter_reddit_clone/core/failure.dart';
import 'package:flutter_reddit_clone/core/provider/storage_repository_provider.dart';
import 'package:flutter_reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:flutter_reddit_clone/features/community/repository/community_repository.dart';
import 'package:flutter_reddit_clone/models/community_model.dart';
import 'package:flutter_reddit_clone/core/utils.dart';
import 'package:flutter_reddit_clone/models/post_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:routemaster/routemaster.dart';

class CommunityController extends StateNotifier<bool> {
  final CommunityRepository _communityRepository;
  final Ref _ref;
  final StorageRepositorty _storageRepository;

  CommunityController(
      {required CommunityRepository communityRepository,
      required Ref ref,
      required StorageRepositorty storageRepository})
      : _communityRepository = communityRepository,
        _storageRepository = storageRepository,
        _ref = ref,
        super(false);

  void createCommunity(String name, BuildContext context) async {
    state = true;
    final uid = _ref.read(userProvider)?.uid ?? '';
    Community community = Community(
      id: name,
      name: name,
      banner: Constant.bannerDefault,
      avatar: Constant.avatarDefault,
      members: [uid],
      mods: [uid],
    );

    final res = await _communityRepository.createCommunity(community);
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        showSnackBar(context, "Community created successfully");
        Routemaster.of(context).pop();
      },
    );
  }

  Stream<List<Community>> getUserCommunities() {
    final uid = _ref.read(userProvider)!.uid;
    return _communityRepository.getUserCommunity(uid);
  }

  Stream<Community> getCommunityByName(String name) =>
      _communityRepository.getCommunityByName(name);

  void editComunity({
    required File? profileFile,
    required File? bannerFile,
    required Community community,
    required BuildContext context,
  }) async {
    state = true;
    if (profileFile != null) {
      final res = await _storageRepository.storeFile(
        path: 'communities/profile',
        id: community.name,
        file: profileFile,
      );

      res.fold(
        (l) => showSnackBar(context, l.message),
        (r) => community = community.copyWith(avatar: r),
      );
    }

    if (bannerFile != null) {
      final res = await _storageRepository.storeFile(
        path: 'communities/banner',
        id: community.name,
        file: bannerFile,
      );

      res.fold(
        (l) => showSnackBar(context, l.message),
        (r) => community = community.copyWith(banner: r),
      );
    }

    final res = await _communityRepository.editComunity(community);
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) => Routemaster.of(context).pop(),
    );
  }

  Stream<List<Community>> searchCommunity(String query) =>
      _communityRepository.searchCommunity(query);

  void joinCommunity(Community community, BuildContext context) async {
    final user = _ref.read(userProvider)!;

    Either<Failure, void> res;
    if (community.members.contains(user.uid)) {
      res = await _communityRepository.leaveCommunity(community.name, user.uid);
    } else {
      res = await _communityRepository.joinCommunity(community.name, user.uid);
    }

    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        if (community.members.contains(user.uid)) {
          showSnackBar(context, "Community left successfully");
        } else {
          showSnackBar(context, "Community join successfully");
        }
      },
    );
  }

  void addMods(
      String communityName, List<String> uids, BuildContext context) async {
    final res = await _communityRepository.addMods(communityName, uids);

    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) => Routemaster.of(context).pop(),
    );
  }

  Stream<List<Post>> getCommunityPost(String name) =>
      _communityRepository.getCommunityPost(name);
}
