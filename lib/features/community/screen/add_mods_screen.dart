import 'package:flutter/material.dart';
import 'package:flutter_reddit_clone/common/error_text.dart';
import 'package:flutter_reddit_clone/common/loader.dart';
import 'package:flutter_reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:flutter_reddit_clone/features/community/controller/community_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddModsScreen extends ConsumerStatefulWidget {
  final String name;
  const AddModsScreen({
    super.key,
    required this.name,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddModsScreenState();
}

class _AddModsScreenState extends ConsumerState<AddModsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.done),
          ),
        ],
      ),
      body: ref.watch(getCommunityByNameProvider(widget.name)).when(
            data: (data) => ListView.builder(
              itemCount: data.members.length,
              itemBuilder: (context, index) {
                final member = data.members[index];

                return ref.watch(getUserDataProvider(member)).when(
                      data: (data) => CheckboxListTile(
                        value: true,
                        onChanged: (value) {},
                        title: Text(data.name),
                      ),
                      error: (error, stackTrace) =>
                          ErrorText(error: error.toString()),
                      loading: () => Loader(),
                    );
              },
            ),
            error: (error, stackTrace) => ErrorText(error: error.toString()),
            loading: () => Loader(),
          ),
    );
  }
}
