#include <iostream>
#include <ostream>
#include <string>
#include <vector>

using namespace std;

struct Cell {
  int index, richness, neigh0, neigh1, neigh2, neigh3, neigh4, neigh5;
};

istream &operator>>(istream &is, Cell &c) {
  return is >> c.index >> c.richness >> c.neigh0 >> c.neigh1 >> c.neigh2 >>
         c.neigh3 >> c.neigh4 >> c.neigh5;
}

struct Tree {
  int cellIndex, size;
  bool isMine, isDormant;
};

istream &operator>>(istream &is, Tree &t) {
  return is >> t.cellIndex >> t.size >> t.isMine >> t.isDormant;
}

struct Action {
  static constexpr char wait_name[]{"WAIT"}, complete_name[]{"COMPLETE"};
  enum class Type { wait, complete } type;
  int index;
};

istream &operator>>(istream &is, Action &a) {
  string name{};
  is >> name;
  if (name == a.wait_name)
    a.type = Action::Type::wait;
  else if (name == a.complete_name) {
    a.type = Action::Type::complete;
    is >> a.index;
  }
  return is;
}

ostream &operator<<(ostream &os, const Action &a) {
  switch (a.type) {
  case Action::Type::wait:
    os << a.wait_name;
    break;
  case Action::Type::complete:
    os << a.complete_name << ' ' << a.index;
  }
  return os;
}

struct Game {
  int day{-1}, nutrients, mySun, myScore, oppSun, oppScore;
  bool oppIsWaiting;
  vector<Cell> cells{};
  vector<Tree> trees{};
  vector<Action> possibleActions{};

  Action pickAction() {
    // TODO Your AI here
    return possibleActions.front();
  }
};

istream &operator>>(istream &is, Game &g) {
  if (g.day == -1) {
    size_t numberOfCells;
    is >> numberOfCells;
    g.cells.resize(numberOfCells);
    for (auto &x : g.cells)
      is >> x;
  }
  is >> g.day >> g.nutrients >> g.mySun >> g.myScore >> g.oppSun >>
      g.oppScore >> g.oppIsWaiting;
  size_t numberOfTrees;
  is >> numberOfTrees;
  g.trees.resize(numberOfTrees);
  for (auto &x : g.trees)
    is >> x;
  size_t numberOfPossibleActions;
  is >> numberOfPossibleActions;
  g.possibleActions.resize(numberOfPossibleActions);
  for (auto &x : g.possibleActions)
    is >> x;
  return is;
}

int main() {
  Game game{};
  while (true) {
    cin >> game;
    cout << game.pickAction() << endl;
  }
}
