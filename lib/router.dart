
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:website/pages/home.dart';
import 'package:website/pages/projects/zombies.dart';

/// The route configuration.
final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const MyHomePage();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'zombies',
          builder: (BuildContext context, GoRouterState state) {
            return const ZombiesPage();
          },
        ),
      ],
    ),
  ],
);