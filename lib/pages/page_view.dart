import 'package:flutter/material.dart';
export 'package:website/router.dart';
import '../widgets/markdown_renderer.dart';
import '../widgets/site_widgets.dart';

export '../widgets/markdown_renderer.dart';
export '../widgets/video_player.dart';
export 'package:url_launcher/url_launcher.dart';
export 'package:flutter/material.dart';


class ProjectPageView extends StatelessWidget {
  final String markdownPath;

  const ProjectPageView({super.key, required this.markdownPath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: siteAppBar(context),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: MarkdownRenderer(path: markdownPath),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
