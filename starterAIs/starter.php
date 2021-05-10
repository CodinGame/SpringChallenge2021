<?php

declare(strict_types=1);

namespace CodinGame\SC2021;

class Cell
{
    public $index = 0;
    public $richness = 0;
    public $neighbours = [];        // array[0..5] of int index
    public const MAX_RICHNESS = 3;
    public const MAX_DIRECTIONS = 6;
    public const RICHNESS_BONUS = [0, 0, 2, 4];
}

class Board
{
    public $numberOfCells = 0;
    public $cells = [];             // array[int idxCell] of Cell
    public const MAX_CELLS = 37;

    public function readInitInput(): void
    {
        $this->cells = [];
        // $numberOfCells: 37
        fscanf(STDIN, "%d", $this->numberOfCells);
        for ($i = 0; $i < $this->numberOfCells; $i++) {
            // $index: 0 is the center cell, the next cells spiral outwards
            // $richness: 0 if the cell is unusable, 1-3 for usable cells
            // $neigh0: the index of the neighbouring cell for each direction
            fscanf(STDIN, "%d %d %d %d %d %d %d %d", $index, $richness, $nb0, $nb1, $nb2, $nb3, $nb4, $nb5);
            $cell = new Cell();
            $cell->index = $index;
            $cell->richness = $richness;
            $cell->neighbours = [$nb0, $nb1, $nb2, $nb3, $nb4, $nb5];
            $this->cells[$index] = $cell;
        }
    }
}

class Tree
{
    public $cellIndex = 0;
    public $size = 0;
    public $isMine = false;
    public $isDormant = false;
    public const MAX_SIZE = 3;
    public const HARVEST_SUNS = [0, 1, 2, 3];

    // only for debugging
    public function toString(): string
    {
        return "[" . $this->cellIndex . ": " . $this->size
            . ($this->isMine ? " M" : " O")
            . ($this->isDormant ? " D" : " -")
            . "]";
    }
}

class Action
{
    public $verb = self::WAIT;
    public $index = 0;
    public $indexTo = 0;
    public $msg = "";
    public const WAIT = 0;
    public const SEED = 1;
    public const GROW = 2;
    public const COMPLETE = 3;
    public const GROW_BASE_COSTS = [1, 3, 7];
    public const COMPLETE_COST = 4;

    public function toString(): string
    {
        // GROW cellIdx | SEED sourceIdx targetIdx | COMPLETE cellIdx | WAIT <message>
        if ($this->verb == self::WAIT) {
            $ans = "WAIT";
        } elseif ($this->verb == self::SEED) {
            $ans = "SEED " . $this->index . " " . $this->indexTo;
        } elseif ($this->verb == self::GROW) {
            $ans = "GROW " . $this->index;
        } elseif ($this->verb == self::COMPLETE) {
            $ans = "COMPLETE " . $this->index;
        } else {
            throw new \Exception("Invalid action");
        }
        if ($this->msg != "") {
            $ans .= " " . $this->msg;
        }
        return $ans;
    }
}

class Game
{
    public $board = null;           // Board
    public $day = 0;
    public $nutrients = 0;
    public $mySun = 0;
    public $myScore = 0;
    public $oppSun = 0;
    public $oppScore = 0;
    public $oppIsWating = false;
    public $numberOfTrees = 0;
    public $trees = [];             // array[int idxCell] of Tree
    public $possibleMoves = [];     // array of string
    public $action = null;          // Action
    public const MAX_DAY = 24;
    public const EXTRA_POINT_PER_SUNS = 3;

    public function readTurnInput(): void
    {
        // $day: the game lasts 24 days: 0-23
        fscanf(STDIN, "%d", $this->day);
        // $nutrients: the base score you gain from the next COMPLETE action
        fscanf(STDIN, "%d", $this->nutrients);
        // $mySun: your sun points
        // $myScore: your current score
        fscanf(STDIN, "%d %d", $this->mySun, $this->myScore);
        // $oppSun: opponent's sun points
        // $oppScore: opponent's score
        // $oppIsWaiting: whether your opponent is asleep until the next day
        fscanf(STDIN, "%d %d %d", $this->oppSun, $this->oppScore, $oppIsWaiting);
        $this->oppIsWating = ($oppIsWaiting == 1);
        // $numberOfTrees: the current amount of trees
        fscanf(STDIN, "%d", $this->numberOfTrees);
        $this->trees = [];
        for ($i = 0; $i < $this->numberOfTrees; $i++) {
            // $cellIndex: location of this tree
            // $size: size of this tree: 0-3
            // $isMine: 1 if this is your tree
            // $isDormant: 1 if this tree is dormant
            fscanf(STDIN, "%d %d %d %d", $cellIndex, $size, $isMine, $isDormant);
            $tree = new Tree();
            $tree->cellIndex = $cellIndex;
            $tree->size = $size;
            $tree->isMine = ($isMine == 1);
            $tree->isDormant = ($isDormant == 1);
            $this->trees[$cellIndex] = $tree;
        }
        fscanf(STDIN, "%d", $numberOfPossibleMoves);
        $this->possibleMoves = [];
        for ($i = 0; $i < $numberOfPossibleMoves; $i++) {
            $this->possibleMoves[] = stream_get_line(STDIN, 31 + 1, "\n");
        }
    }

    public function output(): void
    {
        echo $this->action->toString(), PHP_EOL;
    }

    public function move(): void
    {
        $this->action = new Action(); // defaults to WAIT
        // TODO
    }

    // only for debugging
    public function logState(): void
    {
        error_log("====== Turn"
            . " [day: " . $this->day
            . ", nutr: " . $this->nutrients
            . ", trees: " . $this->numberOfTrees
            . "]");
        error_log("  My: " . $this->mySun
            . " / " . $this->myScore
            . "; Opp: " . $this->oppSun
            . " / " . $this->oppScore
            . " / " . ($this->oppIsWaiting ? "W" : "-"));
        $s = "";
        foreach ($this->trees as $tree) {
            $s .= $tree->toString() . "; ";
        }
        error_log("  Trees: " . $s);
        $s = "";
        foreach ($this->possibleMoves as $move) {
            $s .= $move . "; ";
        }
        error_log("  Possible moves: " . $s);
    }
}

// --- MAIN ---
$g = new Game();
$g->board = new Board();
$g->board->readInitInput();
while (true) {
    $g->readTurnInput();
    // $g->logState();
    $g->move();
    $g->output();
}
// To debug: error_log(var_export($var, true)); (equivalent to var_dump)
