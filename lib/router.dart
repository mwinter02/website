
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:website/pages/home.dart';
import 'package:website/pages/projects.dart';
import 'package:website/pages/projects/collider.dart';
import 'package:website/pages/projects/pngchaser.dart';
import 'package:website/pages/projects/zombies.dart';
import 'package:website/pages/under_construction.dart';

export 'package:go_router/go_router.dart';


class RouteNames {
  RouteNames._();
  static const String home = '/';

  static const String projects = '/projects';
  static const String zombies = '$projects/zombies';
  static const String pngchaser = '$projects/pngchaser';
  static const String collider = '$projects/collider';
  static const String airobic = '$projects/airobic';
  static const String terrain = '$projects/terrain';
}

class Routes {
  Routes._();

  static GoRoute zombies = GoRoute(
    path: RouteNames.zombies,
    builder: (BuildContext context, GoRouterState state) => const ZombiesPage(),
  );

  static GoRoute pngchaser = GoRoute(
    path: RouteNames.pngchaser,
    builder: (BuildContext context, GoRouterState state) => const PngChaserPage(),
  );

  static GoRoute collider = GoRoute(
    path: RouteNames.collider,
    builder: (BuildContext context, GoRouterState state) => const ColliderPage(),
  );

  static GoRoute airobic = GoRoute(
    path: RouteNames.airobic,
    builder: (BuildContext context, GoRouterState state) => const UnderConstruction(),
  );

  static GoRoute terrain = GoRoute(
    path: RouteNames.terrain,
    builder: (BuildContext context, GoRouterState state) => const UnderConstruction(),
  );



  static GoRoute projects = GoRoute(
    path: RouteNames.projects,
    builder: (BuildContext context, GoRouterState state) => const ProjectsPage(),
  );

  static GoRoute home = GoRoute(
    path: RouteNames.home,
    builder: (BuildContext context, GoRouterState state) => const MyHomePage(),
    routes: <RouteBase>[projects, zombies, pngchaser, collider, airobic, terrain],
  );
}

/// The route configuration.
final GoRouter appRouter = GoRouter(
  routes: <RouteBase>[
    Routes.home,
  ],
);