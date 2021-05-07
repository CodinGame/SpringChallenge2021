#include <iostream>
#include <string>
#include <vector>
#include <algorithm>

using namespace std;

class Cell {
public:
    Cell () {
        neighbors.resize(6);
    }
    Cell (int cell_index, int richness, int neighbors) :
    cell_index{cell_index}, richness{richness}, neighbors{neighbors} {}

    void input() {
        cin >> cell_index >> richness;
        for (auto& n: neighbors) {
            cin >> n;
        }
    }
    int cell_index;
    int richness;
    vector<int> neighbors;
};

class Tree {
public:
    Tree () = default;
    Tree (int cell_index, int size, int is_mine, int is_dormant) :
        cell_index{cell_index}, size{size}, is_mine{is_mine}, is_dormant{is_dormant} {}
    void input() {
        int cellIndex;
        int size;
        bool isMine;
        bool isDormant;
        cin >> cellIndex >> size >> isMine >> isDormant;
    }
    int cell_index;
    int size;
    int is_mine;
    int is_dormant;
};

class Game {
private:
        int day = 0;
        int nutrients = 0;
        vector<Cell> board;
        vector<Tree> trees;
        vector<pair<string,int>> possible_actions;
        int mySun;
        int oppSun;
        int score;
        int oppScore;
        int oppIsWaiting;

public:
    void inputInitData() {
        int numberOfCells;
        cin >> numberOfCells;
        for (int i = 0; i < numberOfCells; i++) {
            Cell cell;
            cell.input();
            board.push_back(cell);
        }
    }

    void inputInfo() {
        // input game info
        cin >> day;
        cin >> nutrients;
        cin >> mySun >> score;
        cin >> oppSun >> oppScore >> oppIsWaiting;

        // input trees info
        trees.clear();
        int numberOfTrees;
        cin >> numberOfTrees;
        for (int i = 0; i < numberOfTrees; i++) {
            Tree tree;
            tree.input();
            trees.push_back(tree);
        }

        // input possible actions
        possible_actions.clear();
        int numberOfPossibleMoves;
        cin >> numberOfPossibleMoves;
        for (int i = 0; i < numberOfPossibleMoves; i++) {
            string type;
            int index = 0;
            cin >> type;
            if (type == "COMPLETE") {
                cin >> index;
                possible_actions.emplace_back(type, index);
            }
        }
    }
    //TODO: Please implement the algorithm in this function
    string compute_next_action() {
        string action = "WAIT"; // default
      
        // your algorithm !!

        return action;
    }
};

int main()
{
    Game game;
    game.inputInitData();

    while (true) {
        game.inputInfo();
        
        cout << game.compute_next_action() << endl;
    }
}
