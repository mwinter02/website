import 'pages/home.dart';
import 'pages/page_view.dart';
import 'pages/projects.dart';

export 'package:go_router/go_router.dart';

class Routes {
  Routes._();

  static const String homePath = '/';
  static const String projectsPath = '/projects';



  static final List<GoRoute> projectRoutes = [
    zombies,
    pngchaser,
    collider,
    argo,
    airobic,
    terrain,
    urbanize,
    pacman,
  ];

  static final List<GoRoute> all = [
    home,
    projects,
    ...projectRoutes,
  ];

  static GoRoute getProjectRoute(Project project) {
    return GoRoute(path: project.route,
        builder: (BuildContext context, GoRouterState state) =>
        ProjectPageView(markdownPath: project.markdownPath)
    );
  }

  static GoRoute zombies = getProjectRoute(Projects.zombies);
  static GoRoute pngchaser = getProjectRoute(Projects.pngchaser);
  static GoRoute collider = getProjectRoute(Projects.collider);
  static GoRoute argo = getProjectRoute(Projects.argo);
  static GoRoute urbanize = getProjectRoute(Projects.urbanize);
  static GoRoute airobic = getProjectRoute(Projects.airobic);
  static GoRoute terrain = getProjectRoute(Projects.terrain);
  static GoRoute pacman = getProjectRoute(Projects.pacman);

  static GoRoute projects = GoRoute(
    path: projectsPath,
    builder: (BuildContext context, GoRouterState state) =>
        const ProjectsPage(),
  );

  static GoRoute home = GoRoute(
    path: homePath,
    builder: (BuildContext context, GoRouterState state) => const HomePage(),
    routes: <RouteBase>[projects, ...projectRoutes],
  );
}

/// The route configuration.
final GoRouter appRouter = GoRouter(
  routes: <RouteBase>[Routes.home],
  redirect: (context, state) {
    if (!Routes.all.map((route) => route.path).contains(state.matchedLocation)) {
      return Routes.home.path;
    }
    return null;
  },
);
