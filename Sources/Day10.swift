import AoCCommon
import Collections
import Foundation

struct Day10: AdventDay, Sendable {
  let machines: [Machine]
  let day = 10
  let puzzleName: String = "--- Day 10: Factory ---"

  init(data: String) {
    machines = try! MachinesParser().parse(data)
  }

  func part1() async throws -> Int {
    machines.map(\.minimumPresses).reduce(into: 0, +=)
  }
}

extension Day10 {
  struct Machine: Equatable, Sendable {
    enum IndicatorState: Equatable, Sendable {
      case on
      case off

      init(char: Character) {
        self = switch char {
        case ".": .off
        default: .on
        }
      }
    }

    let indicators: [IndicatorState]
    let wirings: [[Int]]
    let joltages: [Int]

    init(_ parsedLine: ([IndicatorState], [[Int]], [Int])) {
      indicators = parsedLine.0
      wirings = parsedLine.1
      joltages = parsedLine.2
    }

    private var targetMask: Int {
      indicators.enumerated().reduce(0) { acc, pair in
        let (idx, state) = pair
        guard state == .on else { return acc }
        return acc | (1 << idx)
      }
    }

    private func wiringMask(_ indices: [Int]) -> Int {
      indices.reduce(0) { acc, i in
        acc | (1 << i)
      }
    }

    private func apply(_ masks: [Int]) -> Int {
      masks.reduce(into: 0, ^=)
    }

    var minimumPresses: Int {
      let target = targetMask
      let wiringMasks = wirings.map(wiringMask)

      for wiring in wiringMasks.combinations(ofCount: 1 ... wiringMasks.count).lazy {
        if target == apply(wiring) {
          return wiring.count
        }
      }

      return 0
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
        .map { inner in Array(inner).map(Machine.IndicatorState.init) }
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
