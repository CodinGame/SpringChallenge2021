import std;
package: // to avoid 'undocumented public symbol' warnings

void main() {
    Game game;
    game.initalize();
    game.readInput();
    while (1) {
        game.tick();
        game.readInput();
    }
}

struct Cell {
    /// 0 is the center cell, the next cells spiral outwards
    int index;
    /// 0 if the cell is unusable, 1-3 for usable cells
    int richness;
    /// the index of the neighbouring cell for each direction
    int[6] neighbours;
    this(string line) {
        auto inputs = line.split;
        this.index = inputs[0].to!int;
        this.richness = inputs[1].to!int;
        this.neighbours[0..6] = inputs[2..8].map!(to!int).array;
    }
}

struct Player {
    int sunPoints;
    int score;
}

struct Tree {
    int cellIndex; /// location of this tree
    int size; /// size of this tree: 0-3
    bool isMine; /// whether this is your tree
    bool isDormant;

    this(string line) {
        auto s = line.split;
        this.cellIndex = s[0].to!int;
        this.size = s[1].to!int;
        this.isMine = s[2].to!int == 1;
        this.isDormant = s[3].to!int == 1;
    }
}

struct Action {
    enum Type {
        WAIT,
        GROW,
        COMPLETE,
        SEED,
    }
    Type type;
    int cellTarget; // used by GROW, COMPLETE, SEED
    int cellSource; // used by SEED only

    this(string line) {
        auto s = line.split;
        this.type = s[0].to!Type;
        final switch (this.type) {
            case Type.WAIT:
                break;
            case Type.COMPLETE:
            case Type.GROW:
                this.cellTarget = s[1].to!int;
                break;
            case Type.SEED:
                this.cellTarget = s[2].to!int;
                this.cellSource = s[1].to!int;
                break;
        }
    }

    this(Type type, int cellTarget = 0, int cellSource = 0) {
        this.type = type;
        this.cellTarget = cellTarget;
        this.cellSource = cellSource;
    }

    void perform() {
        final switch (this.type) {
            case Type.WAIT:
                writefln("WAIT");
                break;
            case Type.COMPLETE:
            case Type.GROW:
                writefln("%s %d", type, cellTarget);
                break;
            case Type.SEED:
                writefln("%s %d %d", type, cellSource, cellTarget);
                break;
        }
    }
}

struct Game {
    Cell[] cells;
    Player me; /// my score
    Player enemy; /// opponent's score
    bool opponentIsWaiting = false; /// whether your opponent is asleep until the next day
    int day; /// the game lasts 24 days: 0-23
    int nutrients; /// the base score you gain from the next COMPLETE action
    Tree[] trees; /// trees on the board
    Action[] actions; /// all legal actions

    void initalize() {
        const nCells = readln.chomp.to!int; // 37
        this.cells = stdin.byLineCopy.map!(x => Cell(x)).take(nCells).array;
    }

    void readInput() {
        this.day = readln.chomp.to!int;
        this.nutrients = readln.chomp.to!int;

        const inputs0 = readln.split;
        this.me = Player(inputs0[0].to!int, inputs0[1].to!int);
        const inputs1 = readln.split;
        this.enemy = Player(inputs1[0].to!int, inputs1[1].to!int);
        this.opponentIsWaiting = inputs1[2].to!int == 1;

        const nTrees = readln.chomp.to!int; // the current amount of trees
        this.trees = stdin.byLineCopy.map!(x => Tree(x)).take(nTrees).array;
        const nActions = readln.chomp.to!int; // all legal actions
        this.actions = stdin.byLineCopy.map!(x => Action(x)).take(nActions).array;
    }

    void tick() {
        // TODO: write your algorithm here
        actions[0].perform();
        //Action(Action.Type.WAIT).perform();
    }
}
