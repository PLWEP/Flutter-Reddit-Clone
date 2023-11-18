import 'package:flutter/material.dart';
import 'package:flutter_reddit_clone/features/auth/screen/login_screen.dart';
import 'package:flutter_reddit_clone/features/community/screen/community_screen.dart';
import 'package:flutter_reddit_clone/features/community/screen/create_community_screen.dart';
import 'package:flutter_reddit_clone/features/community/screen/edit_community_screen.dart';
import 'package:flutter_reddit_clone/features/community/screen/mod_tools_screen.dart';
import 'package:flutter_reddit_clone/features/home/screen/home_screen.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutRoute = RouteMap(
  routes: {
    '/': (_) => const MaterialPage(child: LoginScreen()),
  },
);

final loggedInRoute = RouteMap(
  routes: {
    '/': (_) => const MaterialPage(child: HomeScreen()),
    '/create-community': (_) =>
        const MaterialPage(child: CreateCommunityScreen()),
    '/r/:name': (route) => MaterialPage(
          child: CommunityScreen(
            name: route.pathParameters['name']!,
          ),
        ),
    '/mod-tools/:name': (route) => MaterialPage(
          child: ModToolScreen(
            name: route.pathParameters['name']!,
          ),
        ),
    '/edit-community/:name': (route) => MaterialPage(
          child: EditCommunityScreen(
            name: route.pathParameters['name']!,
          ),
        ),
  },
);
