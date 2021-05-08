import Glibc
import Foundation

public struct StderrOutputStream: TextOutputStream {
    public mutating func write(_ string: String) { fputs(string, stderr) }
}
public var errStream = StderrOutputStream()

struct Game {
    let cells: [Int: Cell]

    init() {
        let numberOfCells = Int(readLine()!)!
        cells = (0..<numberOfCells).map { _ in
            return Cell()
        }.reduce(into: [:]) { $0[$1.index] = $1 }
    }
}

struct Cell {
    let index: Int
    let richness: Int
    let n0: Int
    let n1: Int
    let n2: Int
    let n3: Int
    let n4: Int
    let n5:Int

    init() {
        let inputs = readLine()!.split(separator: " ").map(String.init)
        index = Int(inputs[0])! // 0 is the center cell, the next cells spiral outwards
        richness = Int(inputs[1])! // 0 if the cell is unusable, 1-3 for usable cells
        n0 = Int(inputs[2])! // the index of the neighbouring cell for each direction
        n1 = Int(inputs[3])!
        n2 = Int(inputs[4])!
        n3 = Int(inputs[5])!
        n4 = Int(inputs[6])!
        n5 = Int(inputs[7])!
    }
}

struct Round {

    let day: Int
    let nutrients: Int
    let sun: Int
    let score: Int
    let oppSun: Int
    let oppScore: Int
    let oppIsWaiting: Bool
    let numberOfTrees: Int
    let trees: [Int: Tree]
    let possibleActions: [Action]
        
    init() {
        day = Int(readLine()!)! // the game lasts 24 days: 0-23
        nutrients = Int(readLine()!)! // the base score you gain from the next COMPLETE action
        let inputs = readLine()!.split(separator: " ")
        sun = Int(inputs[0])! // your sun points
        score = Int(inputs[1])! // your current score
        let inputs2 = readLine()!.split(separator: " ")
        oppSun = Int(inputs2[0])! // opponent's sun points
        oppScore = Int(inputs2[1])! // opponent's score
        oppIsWaiting = inputs2[2] != "0" // whether your opponent is asleep until the next day
        numberOfTrees = Int(readLine()!)! // the current amount of trees
        trees = (0..<numberOfTrees).map { _ in
            let tree = Tree()
            return tree
        }.reduce(into: [:]) { $0[$1.index] = $1 }
        let numberOfinputs = Int(readLine()!)! // all legal actions
        possibleActions = (0..<numberOfinputs).map { _ in
            Action.read()
        }
    }
}

struct Tree {
    let index: Int
    let size: Int
    let mine: Bool
    let dormant: Bool
    
    init() {
        let inputs = readLine()!.split(separator: " ")
        index = Int(inputs[0])! // location of this tree
        size = Int(inputs[1])! // size of this tree: 0-3
        mine = inputs[2] != "0" // 1 if this is your tree
        dormant = inputs[3] != "0" // 1 if this tree is dormant
    }
}

enum Action: CustomStringConvertible {
    case WAIT
    case SEED(sourceIndex: Int, targetIndex:Int)
    case GROW(targetIndex: Int)
    case COMPLETE(targetIndex: Int)

    static func read() -> Action {
        let input = readLine()!.split(separator: " ")
        switch input[0].uppercased() {
            case "SEED":
                return .SEED(sourceIndex: Int(input[1])!, targetIndex: Int(input[2])!)
            case "GROW":
                return .GROW(targetIndex: Int(input[1])!)
            case "COMPLETE":
                return .COMPLETE(targetIndex: Int(input[1])!)
            default:
                return .WAIT
        }
    }

    var description: String {
        switch self {
            case .WAIT: return "WAIT"
            case .SEED(let s, let t): return "SEED \(s) \(t)"
            case .GROW(let t): return "GROW \(t)"
            case .COMPLETE(let t): return "COMPLETE \(t)"
        }
    }
}

let gameInfo = Game()

// game loop
while true {
    let roundInfo = Round()

    //TODO: here you should compute which action to execute on which field

    print(Action.WAIT)
}
