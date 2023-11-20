import 'package:flutter/material.dart';
import 'package:flutter_reddit_clone/common/error_text.dart';
import 'package:flutter_reddit_clone/common/loader.dart';
import 'package:flutter_reddit_clone/features/community/controller/community_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class SearchCommunityDelegate extends SearchDelegate {
  final WidgetRef ref;

  SearchCommunityDelegate(this.ref);

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(Icons.close),
        ),
      ];

  @override
  Widget? buildLeading(BuildContext context) => null;

  @override
  Widget buildResults(BuildContext context) => const SizedBox();

  @override
  Widget buildSuggestions(BuildContext context) =>
      ref.watch(searchCommunitiesProvider(query)).when(
            data: (data) => ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final community = data[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(community.avatar),
                  ),
                  title: Text(community.name),
                  onTap: () => navigateToCommunity(context, community.name),
                );
              },
            ),
            error: (error, stackTrace) => ErrorText(error: error.toString()),
            loading: () => const Loader(),
          );

  void navigateToCommunity(BuildContext context, String name) =>
      Routemaster.of(context).push('/r/$name');
}
