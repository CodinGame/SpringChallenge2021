package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

type Cell struct {
	Index      int
	Richness   int // min: 1, max: 3
	Neighbours []int
}

type Tree struct {
	CellId  int
	Size    int
	Mine    bool
	Dormant bool
}

type Action struct {
	Type       string
	TargetCell int
	SourceCell int
}

type Game struct {
	Day               int
	Nutrients         int
	Board             []Cell
	PossibleActions   []*Action
	Trees             []Tree
	MySun             int
	OpponentSun       int
	MyScore           int
	OpponentScore     int
	OpponentIsWaiting bool
}

var game Game

func (game *Game) move() {
	// Add your game code here
	fmt.Println("WAIT")
	return
}

func main() {
	scanner := bufio.NewScanner(os.Stdin)
	scanner.Buffer(make([]byte, 1000000), 1000000)

	var numberOfCells int
	scanner.Scan()
	fmt.Sscan(scanner.Text(), &numberOfCells)

	game.Nutrients = 20
	game.Board = make([]Cell, numberOfCells)

	for i := 0; i < numberOfCells; i++ {
		var index, richness, neigh0, neigh1, neigh2, neigh3, neigh4, neigh5 int
		scanner.Scan()
		fmt.Sscan(scanner.Text(), &index, &richness, &neigh0, &neigh1, &neigh2, &neigh3, &neigh4, &neigh5)

		game.Board[i] = Cell{
			index,
			richness,
			[]int{
				neigh0, neigh1, neigh2, neigh3, neigh4, neigh5,
			},
		}
	}
	for {
		scanner.Scan()
		fmt.Sscan(scanner.Text(), &game.Day)
		scanner.Scan()
		fmt.Sscan(scanner.Text(), &game.Nutrients)
		scanner.Scan()
		fmt.Sscan(scanner.Text(), &game.MySun, &game.MyScore)

		scanner.Scan()
		var _oppIsWaiting int
		fmt.Sscan(scanner.Text(), &game.OpponentSun, &game.OpponentScore, &_oppIsWaiting)
		game.OpponentIsWaiting = _oppIsWaiting != 0

		var numberOfTrees int
		scanner.Scan()
		fmt.Sscan(scanner.Text(), &numberOfTrees)

		game.Trees = make([]Tree, numberOfTrees)
		queue := make([]*Tree, numberOfTrees)
		for i := 0; i < numberOfTrees; i++ {
			var cellIndex, size int
			var isMine, isDormant bool
			var _isMine, _isDormant int
			scanner.Scan()
			fmt.Sscan(scanner.Text(), &cellIndex, &size, &_isMine, &_isDormant)
			isMine = _isMine != 0
			isDormant = _isDormant != 0

			game.Trees[i] = Tree{cellIndex, size, isMine, isDormant}
			queue[i] = &game.Trees[i]
		}

		var numberOfPossibleMoves int
		scanner.Scan()
		fmt.Sscan(scanner.Text(), &numberOfPossibleMoves)

		game.PossibleActions = make([]*Action, numberOfPossibleMoves)
		for i := 0; i < numberOfPossibleMoves; i++ {
			scanner.Scan()
			possibleMove := scanner.Text()
			toks := strings.Split(possibleMove, " ")
			action := &Action{toks[0], 0, 0}
			switch toks[0] {
			case "COMPLETE":
				action.TargetCell, _ = strconv.Atoi(toks[1])
			case "GROW":
				action.TargetCell, _ = strconv.Atoi(toks[1])
			case "SEED":
				action.SourceCell, _ = strconv.Atoi(toks[1])
				action.TargetCell, _ = strconv.Atoi(toks[2])
			case "WAIT":
				_ = ""
			default:
				panic(fmt.Sprintf("Unexpected action '%s'.", toks[0]))
			}
			game.PossibleActions[i] = action
		}

		game.move()
	}
}
