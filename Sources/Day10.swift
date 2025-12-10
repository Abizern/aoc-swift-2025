import AoCCommon
import Foundation

struct Day10: AdventDay, Sendable {
  let machines: [Machine]
  let day = 10
  let puzzleName: String = "--- Day 10: Factory ---"

  init(data: String) {
    machines = try! MachinesParser().parse(data)
  }

  func part1() async throws -> Int {
    0
  }
}

extension Day10 {
  struct Machine: Equatable, Sendable {
    enum ButtonState: Equatable, Sendable {
      case on
      case off

      init(char: Character) {
        self = switch char {
        case ".": .off
        default: .on
        }
      }
    }

    let buttons: [ButtonState]
    let switches: [[Int]]
    let joltages: [Int]

    init(_ parsedLine: ([ButtonState], [[Int]], [Int])) {
      buttons = parsedLine.0
      switches = parsedLine.1
      joltages = parsedLine.2
    }
  }
}

// Add any specific code for parsing here
extension Day10 {
  struct MachineParser: Parser {
    var body: some Parser<Substring, Machine> {
      Parse {
        Parse {
          "["
          Prefix { $0 != "]" }
          "]"
        }
        .map { inner in Array(inner).map(Machine.ButtonState.init) }
        " "
        Many {
          "("
          Many { Int.parser() } separator: { "," }
          ")"
        } separator: { " " }
        " {"
        Many { Int.parser() } separator: { "," }
        "}"
      }.map(Machine.init)
    }
  }

  struct MachinesParser: Parser {
    var body: some Parser<Substring, [Machine]> {
      Many { MachineParser() } separator: { "\n" }
    }
  }
}
