
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ZombiesPage extends StatelessWidget {
  const ZombiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Zombies'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => context.go('/'),
          child: Text('This is the Zombies page.')

        ),
      ),
    );
  }

}