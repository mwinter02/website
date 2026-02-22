import 'package:flutter/material.dart';
import '../models/project.dart';
import '../router.dart';
import '../widgets/project_gallery.dart';
import '../widgets/site_widgets.dart';

// Re-export Project so existing imports of projects.dart still resolve.
export '../models/project.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Projects registry — single source of truth for all project data
// ─────────────────────────────────────────────────────────────────────────────

class Projects {
  static const String _projectsPath = Routes.projectsPath;
  static const String markdownRootDir = 'assets/markdown/';

  static String getMdPath(String projectName) =>
      '$markdownRootDir$projectName.md';

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
    markdownPath: getMdPath('zombies'),
  );

  static final pngchaser = Project(
    route: '$_projectsPath/pngchaser',
    imagePath: 'assets/images/banners/pngchaser.png',
    title: 'PNG Chaser',
    description:
        'Real-time image processing tool built around custom rendering pipelines.',
    tags: ['C++', 'Game Engines', 'OpenGL', 'GLSL'],
    markdownPath: getMdPath('pngchaser'),
  );

  static final collider = Project(
    route: '$_projectsPath/collider',
    imagePath: 'assets/images/banners/collider.png',
    title: 'Interactive Collider Design',
    description:
        'Interactive collider design tool with real-time feedback for game development and 3D modeling.',
    tags: ['C++', 'Tools'],
    markdownPath: getMdPath('collider'),
  );

  static final terrain = Project(
    route: '$_projectsPath/terrain',
    imagePath: 'assets/images/banners/terrainpainter.png',
    title: 'Terrain Painter',
    description: 'Procedural terrain generation from 2D paintings.',
    tags: ['C++', 'GLSL', 'OpenGL'],
    markdownPath: getMdPath('terrain'),
  );

  static final airobic = Project(
    route: '$_projectsPath/airobic',
    imagePath: 'assets/images/banners/airobic.png',
    title: 'AIRobic',
    description: 'AI powered workout generator.',
    tags: ['AI', 'React', 'Full Stack'],
    markdownPath: getMdPath('airobic'),
  );

  static final urbanize = Project(
    route: '$_projectsPath/urbanize',
    imagePath: 'assets/images/banners/urbanize.png',
    title: 'Urbanize',
    description: 'Attribute trained urban scene generation with GANs.',
    tags: ['Python', 'TensorFlow', 'Deep Learning'],
    markdownPath: getMdPath('urbanize'),
  );

  static final argo = Project(
    route: '$_projectsPath/argo',
    imagePath: 'assets/images/banners/argo.png',
    title: 'ARGO',
    description:
        'Full stack cross-platform recruiting app built with Flutter and Firebase.',
    tags: ['Flutter', 'Firebase', 'Full Stack'],
    markdownPath: getMdPath('argo'),
  );

  static final pacman = Project(
    route: '$_projectsPath/pacman',
    imagePath: 'assets/images/banners/pacman.png',
    title: 'Pacman',
    description:
        'A faithful recreation of the classic arcade game, built in my first semester of coding.',
    tags: ['Java', 'Game Dev'],
    markdownPath: getMdPath('pacman'),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// ProjectsPage — full project gallery at /projects
// ─────────────────────────────────────────────────────────────────────────────

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: siteAppBar(context),
      body: SingleChildScrollView(
        child: ProjectGallery(
          projects: Projects.all,
          showFilters: true,
        ),
      ),
    );
  }
}
