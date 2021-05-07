import math._
import scala.util._
import scala.io.StdIn._
import scala.collection.mutable.ArrayBuffer

case class Cell(index: Int, richness: Int, neighbours: Array[Int])

case class Tree(cellIndex: Int, size: Int, isMine: Boolean, isDormant: Boolean)

object Action {
  val WAIT = "WAIT"
  val SEED = "SEED"
  val GROW = "GROW"
  val COMPLETE = "COMPLETE"

  def parse(action: String): Action = {
    val parts = action.split(" ")
    parts(0) match {
      case WAIT =>
        new Action(WAIT)
      case SEED =>
        new Action(SEED, Integer.valueOf(parts(1)), Integer.valueOf(parts(2)))
      case _ =>
        new Action(parts(0), Integer.valueOf(parts(1)))
    }
  }
}

case class Action(`type`: String, sourceCellIdx: Integer, targetCellIdx: Integer) {
  def this(`type`: String, targetCellIdx: Integer) {
    this(`type`, null, targetCellIdx)
  }

  def this(`type`: String) {
    this(`type`, null, null)
  }

  override def toString: String = {
    if (Action.WAIT.equalsIgnoreCase(`type`)) return Action.WAIT
    if (Action.SEED.equalsIgnoreCase(`type`)) return s"${Action.SEED} $sourceCellIdx $targetCellIdx"
    s"${`type`} $targetCellIdx"
  }
}

class Game() {
  var day = 0
  var nutrients = 0
  var board = ArrayBuffer.empty[Cell]
  var possibleActions = ArrayBuffer.empty[Action]
  var trees = ArrayBuffer.empty[Tree]
  var mySun, opponentSun = 0
  var myScore, opponentScore = 0
  var opponentIsWaiting = false

  def getNextAction(): Action = { // TODO: write your algorithm here
    possibleActions.head
  }
}

/**
 * Auto-generated code below aims at helping you parse
 * the standard input according to the problem statement.
 **/
object Player extends App {
  var game = new Game()

  val numberOfCells = readLine.toInt // 37
  for(i <- 0 until numberOfCells) {
    // index: 0 is the center cell, the next cells spiral outwards
    // richness: 0 if the cell is unusable, 1-3 for usable cells
    // neigh0: the index of the neighbouring cell for each direction
    val Array(index, richness, neigh0, neigh1, neigh2, neigh3, neigh4, neigh5) = (readLine split " ").map (_.toInt)
    val cell = Cell(index, richness, Array(neigh0, neigh1, neigh2, neigh3, neigh4, neigh5))
    game.board += cell
  }

  // game loop
  while(true) {
    game.trees = ArrayBuffer.empty[Tree]
    game.possibleActions = ArrayBuffer.empty[Action]

    game.day = readLine.toInt // the game lasts 24 days: 0-23
    game.nutrients = readLine.toInt // the base score you gain from the next COMPLETE action
    // sun: your sun points
    // score: your current score
    val Array(sun, score) = (readLine split " ").map (_.toInt)
    game.mySun = sun
    game.myScore = score

    // oppSun: opponent's sun points
    // oppScore: opponent's score
    // oppIsWaiting: whether your opponent is asleep until the next day
    val Array(_oppSun, _oppScore, _oppIsWaiting) = readLine split " "
    val oppSun = _oppSun.toInt
    val oppScore = _oppScore.toInt
    val oppIsWaiting = _oppIsWaiting.toInt != 0
    game.opponentSun = oppSun
    game.opponentScore = oppScore
    game.opponentIsWaiting = oppIsWaiting

    val numberOfTrees = readLine.toInt // the current amount of trees
    for(i <- 0 until numberOfTrees) {
      // cellIndex: location of this tree
      // size: size of this tree: 0-3
      // isMine: 1 if this is your tree
      // isDormant: 1 if this tree is dormant
      val Array(_cellIndex, _size, _isMine, _isDormant) = readLine split " "
      val cellIndex = _cellIndex.toInt
      val size = _size.toInt
      val isMine = _isMine.toInt != 0
      val isDormant = _isDormant.toInt != 0
      val tree = Tree(cellIndex, size, isMine, isDormant)
      game.trees += tree
    }
    val numberOfPossibleActions = readLine.toInt // all legal actions
    for(i <- 0 until numberOfPossibleActions) {
      val possibleAction = readLine // try printing something from here to start with
      game.possibleActions += Action.parse(possibleAction)
    }

    // Write an action using println
    // To debug: Console.err.println("Debug messages...")

    // GROW cellIdx | SEED sourceIdx targetIdx | COMPLETE cellIdx | WAIT <message>
    val action = game.getNextAction()
    println(action)
  }
}
