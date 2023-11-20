import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_reddit_clone/common/error_text.dart';
import 'package:flutter_reddit_clone/common/loader.dart';
import 'package:flutter_reddit_clone/core/constant/constant.dart';
import 'package:flutter_reddit_clone/core/utils.dart';
import 'package:flutter_reddit_clone/features/community/provider/auth_provider.dart';
import 'package:flutter_reddit_clone/models/community_model.dart';
import 'package:flutter_reddit_clone/theme/pallete.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dotted_border/dotted_border.dart';

class EditCommunityScreen extends ConsumerStatefulWidget {
  final String name;
  const EditCommunityScreen({
    super.key,
    required this.name,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditCommunityScreenState();
}

class _EditCommunityScreenState extends ConsumerState<EditCommunityScreen> {
  File? bannerFile;
  File? profileFile;

  void selectBannerImage() async {
    final res = await pickImage();

    if (res != null) {
      setState(() {
        bannerFile = File(res.files.first.path!);
      });
    }
  }

  void selectProfileImage() async {
    final res = await pickImage();

    if (res != null) {
      setState(() {
        profileFile = File(res.files.first.path!);
      });
    }
  }

  void save(
    Community community,
  ) =>
      ref.read(communityControllerProvider.notifier).editComunity(
            profileFile: profileFile,
            bannerFile: bannerFile,
            community: community,
            context: context,
          );

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(communityControllerProvider);
    final currentTheme = ref.watch(themeNotifierProvider);

    return ref.watch(getCommunityByNameProvider(widget.name)).when(
          data: (data) => Scaffold(
            backgroundColor: currentTheme.colorScheme.background,
            appBar: AppBar(
              title: const Text("Edit Community"),
              centerTitle: false,
              actions: [
                TextButton(
                  onPressed: () => save(data),
                  child: const Text("Save"),
                ),
              ],
            ),
            body: isLoading
                ? const Loader()
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 200,
                          child: Stack(
                            children: [
                              GestureDetector(
                                onTap: selectBannerImage,
                                child: DottedBorder(
                                  borderType: BorderType.RRect,
                                  radius: const Radius.circular(10),
                                  dashPattern: const [10, 4],
                                  strokeCap: StrokeCap.round,
                                  color:
                                      currentTheme.textTheme.bodyMedium!.color!,
                                  child: Container(
                                    width: double.infinity,
                                    height: 150,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: bannerFile != null
                                        ? Image.file(bannerFile!)
                                        : data.banner.isEmpty ||
                                                data.banner ==
                                                    Constant.bannerDefault
                                            ? const Center(
                                                child: Icon(
                                                  Icons.camera_alt_outlined,
                                                  size: 40,
                                                ),
                                              )
                                            : Image.network(data.banner),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 20,
                                left: 20,
                                child: GestureDetector(
                                  onTap: selectProfileImage,
                                  child: profileFile != null
                                      ? CircleAvatar(
                                          backgroundImage: FileImage(
                                            profileFile!,
                                          ),
                                          radius: 32,
                                        )
                                      : CircleAvatar(
                                          backgroundImage: NetworkImage(
                                            data.avatar,
                                          ),
                                          radius: 32,
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader(),
        );
  }
}
