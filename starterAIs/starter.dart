/// This a starter AIs to help new player written in Dart
/// Use Dart version 2.12.4 which supports sound null safety.
import 'dart:io';

void debug(Object obj) {
  stderr.writeln(obj);
}

class Cell {
  final int index;
  final int richness;
  final List<int> neighbors;

  Cell(this.index, this.richness, this.neighbors);
}

class Tree {
  final int index;
  final int size;
  final bool isMine;
  final bool isDormant;

  Tree(this.index, this.size, this.isMine, this.isDormant);
}

class Action {
  static const String wait = 'WAIT';
  static const String seed = 'SEED';
  static const String grow = 'GROW';
  static const String complete = 'COMPLETE';

  final String type;
  final int? sourceCellIdx;
  final int? targetCellIdx;

  Action(
    this.type, [
    this.targetCellIdx,
    this.sourceCellIdx,
  ]);

  static parse(String action) {
    debug(action);
    List<String> parts = action.split(' ');

    switch (parts[0]) {
      case wait:
        return Action(wait);
      case seed:
        return Action(seed, int.parse(parts[2]), int.parse(parts[1]));
      default:
        return Action(parts[0], int.parse(parts[1]));
    }
  }

  @override
  String toString() {
    if (type == wait) {
      return wait;
    } else if (type == seed) {
      return '$seed $sourceCellIdx $targetCellIdx';
    } else {
      return '$type $targetCellIdx';
    }
  }
}

class Game {
  List<Cell> board = [];
  List<Action> possibleActions = [];
  List<Tree> trees = [];
  late int day;
  late int nutrients;
  late int mySun, opponentSun;
  late int myScore, opponentScore;
  late bool opponentIsWaiting;

  Game();

  Action getNextAction() {
    // TODO: write your algorithm here
    return this.possibleActions[0];
  }
}

String readLineSync() {
  String? s = stdin.readLineSync();
  return s == null ? '' : s;
}

/**
 * Auto-generated code below aims at helping you parse
 * the standard input according to the problem statement.
 **/
void main() {
  Game game = Game();

  List inputs;
  int numberOfCells = int.parse(readLineSync()); // 37
  for (int i = 0; i < numberOfCells; i++) {
    inputs = readLineSync().split(' ');
    int index = int.parse(
        inputs[0]); // 0 is the center cell, the next cells spiral outwards
    int richness =
        int.parse(inputs[1]); // 0 if the cell is unusable, 1-3 for usable cells
    int neigh0 = int.parse(
        inputs[2]); // the index of the neighbouring cell for each direction
    int neigh1 = int.parse(inputs[3]);
    int neigh2 = int.parse(inputs[4]);
    int neigh3 = int.parse(inputs[5]);
    int neigh4 = int.parse(inputs[6]);
    int neigh5 = int.parse(inputs[7]);

    List<int> neighs = [neigh0, neigh1, neigh2, neigh3, neigh4, neigh5];
    Cell cell = Cell(index, richness, neighs);

    game.board.add(cell);
  }

  // game loop
  while (true) {
    game.day = int.parse(readLineSync()); // the game lasts 24 days: 0-23
    game.nutrients = int.parse(
        readLineSync()); // the base score you gain from the next COMPLETE action
    inputs = readLineSync().split(' ');
    game.mySun = int.parse(inputs[0]); // your sun points
    game.myScore = int.parse(inputs[1]); // your current score
    inputs = readLineSync().split(' ');
    game.opponentScore = int.parse(inputs[0]); // opponent's sun points
    game.opponentScore = int.parse(inputs[1]); // opponent's score
    game.opponentIsWaiting = int.parse(inputs[2]) !=
        0; // whether your opponent is asleep until the next day

    game.trees.clear();

    int numberOfTrees =
        int.parse(readLineSync()); // the current amount of trees
    for (int i = 0; i < numberOfTrees; i++) {
      inputs = readLineSync().split(' ');
      int cellIndex = int.parse(inputs[0]); // location of this tree
      int size = int.parse(inputs[1]); // size of this tree: 0-3
      bool isMine = int.parse(inputs[2]) != 0; // 1 if this is your tree
      bool isDormant = int.parse(inputs[3]) != 0; // 1 if this tree is dormant
      Tree tree = Tree(cellIndex, size, isMine, isDormant);
      game.trees.add(tree);
    }

    game.possibleActions.clear();

    int numberOfPossibleActions =
        int.parse(readLineSync()); // all legal actions
    for (int i = 0; i < numberOfPossibleActions; i++) {
      String possibleAction =
          readLineSync(); // try printing something from here to start with
      game.possibleActions.add(Action.parse(possibleAction));
    }

    // Write an action using print()
    // To debug: stderr.writeln('Debug messages...');

    // GROW cellIdx | SEED sourceIdx targetIdx | COMPLETE cellIdx | WAIT <message>
    Action action = game.getNextAction();
    print(action);
  }
}
