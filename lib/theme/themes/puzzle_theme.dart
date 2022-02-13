import 'dart:ui';

import 'package:planets/layout/layout.dart';

abstract class PuzzleTheme {
  const PuzzleTheme();

  String get name;

  Color get primary;
  Color get onPrimary;

  Color get surface;
  Color get onSurface;

  String get backgroundAsset;

  PuzzleLayoutDelegate get puzzleLayoutDelegate;

  String get assetForTile;
}