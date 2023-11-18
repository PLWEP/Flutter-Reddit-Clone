import 'package:flutter/material.dart';
import 'package:flutter_reddit_clone/features/auth/screen/login_screen.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutRoute = RouteMap(
  routes: {
    '/': (_) => const MaterialPage(child: LoginScreen()),
  },
);
