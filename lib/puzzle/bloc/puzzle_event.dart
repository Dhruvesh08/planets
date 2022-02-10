part of 'puzzle_bloc.dart';

abstract class PuzzleEvent extends Equatable {
  const PuzzleEvent();

  @override
  List<Object> get props => [];
}

class PuzzleInitialized extends PuzzleEvent {
  const PuzzleInitialized({required this.shufflePuzzle});

  final bool shufflePuzzle;

  @override
  List<Object> get props => [shufflePuzzle];
}

class TileTapped extends PuzzleEvent {
  const TileTapped({required this.tile});

  final Tile tile;

  @override
  List<Object> get props => [tile];
}

class PuzzleAutoSolve extends PuzzleEvent {
  const PuzzleAutoSolve();
}

class PuzzleReset extends PuzzleEvent {
  const PuzzleReset();
}