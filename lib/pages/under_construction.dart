

import 'package:flutter/material.dart';

class UnderConstruction extends StatelessWidget {
  const UnderConstruction({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'This page is under construction.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}