import '../router.dart';
import '../widgets/dynamic_widget.dart';

class Project {
  final String route;
  final String title;
  final String imagePath;
  final String description;
  final String markdownPath;
  final List<String> tags;

  Project({
    required this.route,
    required this.title,
    required this.imagePath,
    required this.description,
    required this.markdownPath,
    required this.tags,
  });
}

class Projects {

  static const String _projectsPath = Routes.projectsPath;

  static final List<Project> all = [
    zombies,
    pngchaser,
    collider,
    argo,
    airobic,
    terrain,
    urbanize,
    pacman,
  ];

  static final zombies = Project(
    route: '$_projectsPath/zombies',
    imagePath: 'assets/images/banners/zombies.png',
    title: 'Zombies',
    description:
        'A top-down survival shooter with procedural pathfinding and skeletal animation.',
    tags: const ['Game Engines', 'Java'],
    markdownPath: 'markdown/zombies.md',
  );
  static final pngchaser = Project(
    route: '$_projectsPath/pngchaser',
    imagePath: 'assets/images/banners/pngchaser.png',
    title: 'PNG Chaser',
    description:
        'Real-time image processing tool built around custom rendering pipelines.',
    tags: ['C++', 'Game Engines', 'OpenGL', 'GLSL'],
    markdownPath: 'markdown/pngchaser.md',
  );

  static final collider = Project(
    route: '$_projectsPath/collider',
    imagePath: 'assets/images/banners/collider.png',
    title: 'Interactive Collider Design',
    description:
        'Interactive collider design too with real-time feedback for game development and 3D modeling',
    tags: ['C++', 'Tools'],
    markdownPath: 'markdown/collider.md',
  );
  static final terrain = Project(
    route: '$_projectsPath/terrain',
    imagePath: 'assets/images/banners/terrainpainter.png',
    title: 'Terrain Painter',
    description: 'Procedural terrain generation from 2D paintings',
    tags: ['C++', 'GLSL', 'OpenGL'],
    markdownPath: 'markdown/terrain.md',
  );
  static final airobic = Project(
    route: '$_projectsPath/airobic',
    imagePath: 'assets/images/banners/airobic.png',
    title: 'AIRobic',
    description: 'AI powered workout generator',
    tags: ['AI', 'React', 'Full Stack'],
    markdownPath: 'markdown/airobic.md',
  );
  static final urbanize = Project(
    route: '$_projectsPath/urbanize',
    imagePath: 'assets/images/banners/urbanize.png',
    title: 'Urbanize',
    description: 'Attribute trained Urban scene generation with GANs',
    tags: ['Python', 'TensorFlow', 'Deep Learning'],
    markdownPath: 'markdown/urbanize.md',
  );
  static final argo = Project(
    route: '$_projectsPath/argo',
    imagePath: 'assets/images/banners/argo.png',
    title: 'ARGO',
    description:
        'Full stack cross-platform recruiting app built with Flutter and Firebase',
    tags: ['Flutter', 'Firebase', 'Full Stack'],
    markdownPath: 'markdown/argo.md',
  );

  static final pacman = Project(
    route: '$_projectsPath/pacman',
    imagePath: 'assets/images/banners/pacman.png',
    title: 'Pacman',
    description: 'A faithful recreation of the classic arcade game, built in my first semester of coding.',
    tags: ['Java', 'Game Dev'],
    markdownPath: 'markdown/pacman.md',
  );
}



class ProjectsPage extends DynamicWidget {
  const ProjectsPage({super.key});

  @override
  Widget desktopView(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Projects')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [],
        ),
      ),
    );
  }

  @override
  Widget mobileView(BuildContext context) {
    return const Text('Projects Page - Mobile');
  }
}
