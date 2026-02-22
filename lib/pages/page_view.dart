import 'package:flutter/material.dart';
export 'package:website/router.dart';
import 'package:website/theme/text_theme.dart';
import 'package:website/widgets/site_widgets.dart';

export 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
export '../widgets/video_player.dart';
export 'package:url_launcher/url_launcher.dart';

class ProjectPageView extends StatelessWidget {
  final Column content;

  const ProjectPageView({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: siteAppBar(context),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: 800),
            child: content,
          ),
        ),
      ),
    );
  }
}
