import math._
import scala.util._
import scala.io.StdIn._
import scala.util.matching.Regex
import scala.annotation.tailrec


object Player extends App {
  import IOUtils._

  val defaultCells = parseCells()

  // game loop
  while(true) {
    implicit val gameState = parseGameState(defaultCells)
    Wait().execute()

    // play(gameState)
  }
}

sealed abstract class Richness(val ord: Int) extends Ordered[Richness] {
  override def compare(that: Richness): Int = this.ord.compare(that.ord)
}
  case object Unusable      extends Richness(0)
  case object LowQuality    extends Richness(1)
  case object MediumQuality extends Richness(2)
  case object HighQuality   extends Richness(3)

case class Cell(richness: Richness, neighbors: Vector[Int], tree: Option[Tree])

sealed abstract class Size(val ord: Int) extends Ordered[Size] {
  override def compare(that: Size): Int = this.ord.compare(that.ord)
}
  case object Root   extends Size(0)
  case object Small  extends Size(1)
  case object Medium extends Size(2)
  case object Large  extends Size(3)

case class Tree(
  cellIndex: Int,
  size: Size,
  isMine: Boolean,
  isDormant: Boolean,
)

case class GameState(
  day: Int,
  nutrients: Int,
  sun: Int,
  score: Int,
  oppSun: Int,
  oppScore: Int,
  oppIsWaiting: Boolean,
  cells: Vector[Cell],
  possibleMoves: Vector[Action],
  seedCost: Int,
)

sealed abstract class Action {
  def execute(debugMsg: String = ""): Unit
}

object Action {
  val growSignature: Regex = """GROW (\d+)""".r
  val seedSignature: Regex = """SEED (\d+) (\d+)""".r
  val completeSignature: Regex = """COMPLETE (\d+)""".r
  val waitSignature: Regex = """WAIT""".r
}

case class Grow(index: Int, cell: Cell, cost: Int) extends Action {
  override def execute(debugMsg: String = ""): Unit = {
    println(s"GROW $index $debugMsg")
  }
}

case class Seed(
  sourceIndex: Int,
  destinationIndex: Int,
  sourceCell: Cell,
  destinationCell: Cell,
) extends Action {
  override def execute(debugMsg: String = ""): Unit = {
    println(s"SEED $sourceIndex $destinationIndex $debugMsg")
  }
}

case class Complete(index: Int, cell: Cell) extends Action {
  override def execute(debugMsg: String = ""): Unit = {
    println(s"COMPLETE $index $debugMsg")
  }
}

case class Wait() extends Action {
  override def execute(debugMsg: String = ""): Unit = {
    println(s"WAIT $debugMsg")
  }
}

object IOUtils {
  def parseCells(): Vector[Cell] =
    Vector.tabulate(readLine().toInt) { _ =>
      val Array(index, richness, neigh0, neigh1, neigh2, neigh3, neigh4, neigh5) = (readLine() split " ").map (_.toInt)

      Cell(
        richness match {
          case 0 => Unusable
          case 1 => LowQuality
          case 2 => MediumQuality
          case 3 => HighQuality
          case _ => throw new IllegalArgumentException()
        },
        neighbors = Vector(neigh0, neigh1, neigh2, neigh3, neigh4, neigh5),
        tree = None
      )
    }

  def parseGameState(defaultCells: Vector[Cell]): GameState = {
    val day = readLine().toInt // the game lasts 24 days: 0-23
    val nutrients = readLine().toInt

    val Array(sun, score) = (readLine() split " ").map (_.toInt)

    val Array(_oppSun, _oppScore, _oppIsWaiting) = readLine() split " "
    val oppSun = _oppSun.toInt
    val oppScore = _oppScore.toInt
    val oppIsWaiting = _oppIsWaiting.toInt != 0

    val trees: Vector[Tree] = Vector.tabulate(readLine().toInt) { _ =>
      val Array(_cellIndex, _size, _isMine, _isDormant) = readLine() split " "

      Tree(
        cellIndex = _cellIndex.toInt,
        size = _size.toInt match {
          case 0 => Root
          case 1 => Small
          case 2 => Medium
          case 3 => Large
          case _ => throw new IllegalArgumentException()
        },
        isMine = _isMine.toInt != 0,
        isDormant = _isDormant.toInt != 0,
      )
    }

    val growCost: Map[Size, Int] = Map(
      Root -> (1 + trees.count(t => t.size == Small  && t.isMine)),
      Small -> (3 + trees.count(t => t.size == Medium && t.isMine)),
      Medium -> (7 + trees.count(t => t.size == Large  && t.isMine)),
    )

    val seedCost: Int = trees.count(t => t.isMine && t.size == Root)

    val indexedTrees = trees.groupBy(_.cellIndex).view.mapValues(_.head).toMap
    val cells = defaultCells.zipWithIndex.map {
      case (cell, index) => cell.copy(tree = indexedTrees.get(index))
    }

    val possibleMoves = Vector.tabulate(readLine().toInt) { _ =>
      readLine() match {
        case               Action.growSignature(index) => Grow(index.toInt, cells(index.toInt), growCost(cells(index.toInt).tree.get.size))
        case Action.seedSignature(source, destination) => Seed(source.toInt, destination.toInt, cells(source.toInt), cells(destination.toInt))
        case           Action.completeSignature(index) => Complete(index.toInt, cells(index.toInt))
        case                    Action.waitSignature() => Wait()
        case _ => throw new IllegalArgumentException()
      }
    }

    GameState(day, nutrients, sun, score, oppSun, oppScore, oppIsWaiting, cells, possibleMoves, seedCost)
  }
}
