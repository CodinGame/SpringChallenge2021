import java.util.*
import java.io.*
import java.math.*

sealed class Action {
    data class Complete(val index: Int) : Action()
    data class Grow(val index: Int) : Action()
    data class Seed(val from: Int, val to: Int) : Action()
    data class Wait(val say: String) : Action()

    // GROW cellIdx | SEED sourceIdx targetIdx | COMPLETE cellIdx | WAIT <message>
    fun toOutput() = when (this) {
        is Action.Complete -> "COMPLETE $index"
        is Action.Grow -> "GROW $index"
        is Action.Seed -> "SEED $from $to" 
        is Action.Wait -> "WAIT $say"
    }

    companion object {
        fun of(st: String): Action = st.split(" ").let { 
            when(it[0]) {
                "COMPLETE" -> Complete(it[1].toInt())
                "GROW" -> Grow(it[1].toInt())
                "SEED" -> Seed(it[1].toInt(), it[2].toInt()) 
                "WAIT" -> Wait("")
                else -> error("unknow Action $st")
            }
        }
    }
}

data class Cell(val index: Int, val richness: Int, val neigh: Array<Int>)
data class Tree(val cellIndex: Int, val size: Int, val isMine: Boolean, val isDormant: Boolean)

class Game(val input: Scanner) {

    // index 0 is the center cell, the next cells spiral outwards
    // richness 0 if the cell is unusable, 1-3 for usable cells
    val nbCells = input.nextInt() // 37
    val cells = List(nbCells) {
        Cell(input.nextInt(), input.nextInt(), Array(6) { input.nextInt() })
    }

    var day: Int = -1 // the game lasts 24 days: 0-23
    var nutrients: Int = -1 // the base score you gain from the next COMPLETE action
    var sun: Int = -1 // your sun points
    var score: Int = -1 // your current score
    var oppSun: Int = -1 // opponent's sun points
    var oppScore: Int = -1 // opponent's score
    var oppIsWaiting: Boolean = false // whether your opponent is asleep until the next day
    var trees: List<Tree> = emptyList()
    var possibleMoves: List<Action> = emptyList()

    fun read() {
        day = input.nextInt() 
        nutrients = input.nextInt() 
        sun = input.nextInt() 
        score = input.nextInt() 
        oppSun = input.nextInt() 
        oppScore = input.nextInt() 
        oppIsWaiting = input.nextInt() != 0 
        val numberOfTrees = input.nextInt()
        trees = List(numberOfTrees) { 
            Tree(input.nextInt(), input.nextInt(), input.nextInt() != 0, input.nextInt() != 0)
        }
        val numberOfPossibleMoves = input.nextInt()
        if (input.hasNextLine()) {
            input.nextLine()
        }
        possibleMoves = List(numberOfPossibleMoves) { Action.of(input.nextLine()) }
    }
}


fun main(args : Array<String>) {
    val input = Scanner(System.`in`)
    val game = Game(input)

    // game loop
    while (true) {
        game.read()

        // Write an action using println()
        // To debug: System.err.println("Debug messages...");

        println(game.possibleMoves.first().toOutput())
    }
}
