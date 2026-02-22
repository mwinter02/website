import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:url_launcher/url_launcher.dart';
import 'video_player.dart';

class MarkdownRenderer extends StatelessWidget {
  final String path;

  const MarkdownRenderer({super.key, required this.path});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: DefaultAssetBundle.of(context).loadString(path),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error loading markdown: ${snapshot.error}'));
        } else {
          return MarkdownImplementation(data: snapshot.data ?? '');
        }
      },
    );
  }
}

class MarkdownImplementation extends StatelessWidget {
  final String data;

  const MarkdownImplementation({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return MarkdownBody(
      data: data,
      // Tell the markdown parser to recognise <video src="..."> as a block.
      blockSyntaxes: [_VideoBlockSyntax()],
      builders: {
        'video': _VideoElementBuilder(),
      },
      onTapLink: (text, href, title) async {
        if (href != null) {
          final Uri url = Uri.parse(href);
          if (await canLaunchUrl(url)) {
            await launchUrl(url);
          } else {
            throw 'Could not launch $url';
          }
        }
      },
      styleSheet: MarkdownStyleSheet(
        blockquoteDecoration: const BoxDecoration(
          color: Color(0xFF1E1E1E),
          border: Border(left: BorderSide(color: Colors.blue, width: 4)),
        ),
        codeblockDecoration: BoxDecoration(
          color: Colors.grey.shade900,
          borderRadius: BorderRadius.circular(4),
        ),
        code: const TextStyle(fontFamily: 'JetBrainsMono'),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _VideoBlockSyntax
//
// Matches a line of the form:
//   <video src="some_file.mp4"></video>
//
// Produces an md.Element with tag "video" and attribute src="some_file.mp4".
// The flutter_markdown_plus builders map then routes this to _VideoElementBuilder.
// ─────────────────────────────────────────────────────────────────────────────

class _VideoBlockSyntax extends md.BlockSyntax {
  // Matches:  <video src="anything.mp4"></video>  (whitespace tolerant)
  static final _pattern =
      RegExp(r'^\s*<video\s+src="([^"]+)"\s*>\s*</video>\s*$');

  @override
  RegExp get pattern => _pattern;

  @override
  bool canParse(md.BlockParser parser) =>
      _pattern.hasMatch(parser.current.content);

  @override
  md.Node parse(md.BlockParser parser) {
    final match = _pattern.firstMatch(parser.current.content)!;
    final src = match.group(1)!;
    parser.advance();

    final element = md.Element.empty('video');
    element.attributes['src'] = src;
    return element;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _VideoElementBuilder
//
// Receives the "video" element produced by _VideoBlockSyntax and renders a
// SimpleWebVideoPlayer.
// ─────────────────────────────────────────────────────────────────────────────

class _VideoElementBuilder extends MarkdownElementBuilder {
  @override
  bool isBlockElement() => true;

  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    final src = element.attributes['src'];
    if (src == null || src.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: SimpleWebVideoPlayer(videoPath: src),
    );
  }
}


