package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

/**
 * Auto-generated code below aims at helping you parse
 * the standard input according to the problem statement.
 **/

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

// Create forest
var game Game

func (game *Game) move() {
	// Re-arrange tree pointers in queue by cell richness
	numberOfTrees := len(game.Trees)
	trees := make([]*Tree, numberOfTrees)
	for i := 0; i < numberOfTrees; i++ {
		trees[i] = &game.Trees[i]
	}
	for i := 0; i < numberOfTrees; i++ {
		c1 := game.Board[trees[i].CellId]
		bias1 := ((c1.Richness - 1) * 2) + game.Nutrients
		for j := 0; j < numberOfTrees; j++ {
			if i == j {
				continue
			}
			c2 := game.Board[trees[j].CellId]
			bias2 := ((c2.Richness - 1) * 2) + game.Nutrients
			if bias2 < bias1 {
				// Swap pointers
				t := trees[j]
				trees[j] = trees[i]
				trees[i] = t
			}
		}
	}

	// Pick off first one that belongs to us that is fully grown
	var chosen *Cell = nil
	for i := 0; i < numberOfTrees; i++ {
		t := *trees[i]
		if t.Mine && t.Size > 2 {
			chosen = &game.Board[t.CellId]
			break
		}
	}
	if chosen != nil && game.MySun > 4 {
		game.Nutrients = game.Nutrients - 1
		fmt.Printf("COMPLETE %d\n", chosen.Index)
		return
	}

	// Re-arrange cell pointers in queue by cell richness
	// numberOfCells := len(game.Board)
	// cells := make([]*Cell, numberOfCells)
	// for i := 0; i < numberOfCells; i++ {
	// 	cells[i] = &game.Board[i]
	// }
	// for i := 0; i < numberOfCells; i++ {
	// 	c1 := cells[i]
	// 	// TODO: Fix algo...
	// 	bias1 := ((c1.Richness - 1) * 2) + game.Nutrients
	// 	for j := 0; j < numberOfCells; j++ {
	// 		if i == j {
	// 			continue
	// 		}
	// 		c2 := cells[j]
	// 		bias2 := ((c2.Richness - 1) * 2) + game.Nutrients
	// 		if bias2 < bias1 {
	// 			// Swap pointers
	// 			c := cells[j]
	// 			cells[j] = cells[i]
	// 			cells[i] = c
	// 		}
	// 	}
	// }
	//

	// Pick off first one that belongs to us that is not yet fully grown
	for i := 0; i < numberOfTrees; i++ {
		t := *trees[i]
		if t.Mine && t.Size < 3 {
			chosen = &game.Board[t.CellId]
			break
		}
	}
	if chosen != nil && game.MySun > 4 {
		fmt.Printf("GROW %d\n", chosen.Index)
		return
	}

	// If not, wait.
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
