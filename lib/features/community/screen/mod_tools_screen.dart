import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

class ModToolScreen extends StatelessWidget {
  final String name;
  const ModToolScreen({
    super.key,
    required this.name,
  });

  void navigateToEditCommunity(BuildContext context) =>
      Routemaster.of(context).push('/edit-community/$name');

  void navigateToAddMods(BuildContext context) =>
      Routemaster.of(context).push('/add-mods/$name');

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Mod Tools'),
        ),
        body: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.add_moderator),
              title: const Text('Add Moderators'),
              onTap: () => navigateToAddMods(context),
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Community'),
              onTap: () => navigateToEditCommunity(context),
            ),
          ],
        ),
      );
}
