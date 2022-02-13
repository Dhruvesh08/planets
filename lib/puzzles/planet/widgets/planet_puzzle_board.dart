import 'package:flutter/material.dart';

class PlanetPuzzleBoard extends StatelessWidget {
  final int size;
  final List<Widget> tiles;

  const PlanetPuzzleBoard({Key? key, required this.size, required this.tiles})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 500, // TODO: HOW TO GET DIMENSION?
      child: Stack(
        children: tiles,
      ),
    );
  }
}
