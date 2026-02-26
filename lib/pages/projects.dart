import 'package:flutter/material.dart';
import '../models/project.dart';
import '../router.dart';
import '../sources.dart';
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
    pngchaser,
    zombies,
    collider,
    argo,
    terrain,
    urbanize,
    airobic,
    pacman,
  ];

  static final zombies = Project(
    route: '$_projectsPath/zombies',
    imagePath: AssetSources.bannerZombies,
    title: 'Zombies',
    description:
        'A top-down survival shooter with procedural pathfinding and skeletal animation.',
    tags: const ['Game Engines', 'Java'],
    markdownPath: getMdPath('zombies'),
  );

  static final pngchaser = Project(
    route: '$_projectsPath/pngchaser',
    imagePath: AssetSources.bannerPngChaser,
    title: 'PNG Chaser',
    description:
        'Real-time image processing tool built around custom rendering pipelines.',
    tags: ['C++', 'Game Engines', 'OpenGL', 'GLSL'],
    markdownPath: getMdPath('pngchaser'),
  );

  static final collider = Project(
    route: '$_projectsPath/collider',
    imagePath: AssetSources.bannerCollider,
    title: 'Interactive Collider Design',
    description:
        'Interactive collider design tool with real-time feedback for game development and 3D modeling.',
    tags: ['C++', 'Tools'],
    markdownPath: getMdPath('collider'),
  );

  static final terrain = Project(
    route: '$_projectsPath/terrain',
    imagePath: AssetSources.bannerTerrain,
    title: 'Terrain Painter',
    description: 'Procedural terrain generation from 2D paintings.',
    tags: ['C++', 'GLSL', 'OpenGL'],
    markdownPath: getMdPath('terrain'),
  );

  static final airobic = Project(
    route: '$_projectsPath/airobic',
    imagePath: AssetSources.bannerAirobic,
    title: 'AIRobic',
    description: 'AI powered workout generator.',
    tags: ['AI', 'React', 'Full Stack'],
    markdownPath: getMdPath('airobic'),
  );

  static final urbanize = Project(
    route: '$_projectsPath/urbanize',
    imagePath: AssetSources.bannerUrbanize,
    title: 'Urbanize',
    description: 'Attribute trained urban scene generation with GANs.',
    tags: ['Python', 'TensorFlow', 'Deep Learning'],
    markdownPath: getMdPath('urbanize'),
  );

  static final argo = Project(
    route: '$_projectsPath/argo',
    imagePath: AssetSources.bannerArgo,
    title: 'ARGO',
    description:
        'Full stack cross-platform recruiting app built with Flutter and Firebase.',
    tags: ['Flutter', 'Firebase', 'Full Stack'],
    markdownPath: getMdPath('argo'),
  );

  static final pacman = Project(
    route: '$_projectsPath/pacman',
    imagePath: AssetSources.bannerPacman,
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
