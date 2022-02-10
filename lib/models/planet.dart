import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../dashboard/dashboard.dart';
import 'coordinate.dart';

class Planet extends Equatable {
  final String name;
  final int key;
  final Coordinate origin;
  final double r1;
  final double r2;
  final double planetSize;
  final Size parentSize;

  const Planet({
    required this.key,
    required this.name,
    required this.origin,
    required this.r1,
    required this.r2,
    required this.planetSize,
    required this.parentSize,
  });

  Widget get widget => PlanetWidget(planet: this);

  @override
  List<Object?> get props => [name, origin, r1, r2];
}