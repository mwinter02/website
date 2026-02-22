import 'package:flutter/material.dart';
import 'package:website/theme/text_theme.dart';
import 'package:website/theme/theme.dart';
import 'package:website/widgets/dynamic_widget.dart';
import 'package:website/router.dart';
import 'package:website/widgets/profile_card.dart';
import 'package:website/widgets/project_card.dart';
import 'package:website/widgets/site_widgets.dart';

class MyHomePage extends DynamicStatefulWidget {
  const MyHomePage({super.key});

  @override
  DynamicState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends DynamicState<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget desktopView(BuildContext context) {
    return Scaffold(
      appBar: siteAppBar(context),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Display the SVG asset
              ProfileCard(),
              _projectTile(context),
              _projectsBanner(context),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget mobileView(BuildContext context) {
    return desktopView(context);
  }

  Widget _projectTile(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [ThemeColors.appBarStart, ThemeColors.appBarEnd],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        border: Border(
          top: BorderSide(color: ThemeColors.appBarAccent, width: 1.5),
          bottom: BorderSide(color: ThemeColors.appBarAccent, width: 1.5),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          'Projects',
          style: AppTextTheme.display.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 32,
          ),
        ),
      ),
    );
  }


  Widget _projectsBanner(BuildContext context) {
    List<Widget> projectCards = [
      ProjectCard(
        route: RouteNames.zombies,
        imagePath: 'assets/images/banners/zombies.png',
        title: 'Zombies',
      ),
      ProjectCard(
        route: RouteNames.pngchaser,
        imagePath: 'assets/images/banners/pngchaser.png',
        title: 'PNG Chaser',
      ),
      ProjectCard(
        route: RouteNames.collider,
        imagePath: 'assets/images/banners/collider.png',
        title: 'Interactive Collider Design',
      )
      // Add more project cards here as needed
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 8.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 16 / 9,
        ),
        itemCount: projectCards.length,
        itemBuilder: (context, index) => projectCards[index],
      ),
    );
  }

  Widget _profilePicture(BuildContext context) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: AssetImage('assets/images/profile_picture.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
