import AoCCommon
import Collections
import Foundation

struct Day11: AdventDay, Sendable {
  let adjacency: [String: [String]]
  let day = 11
  let puzzleName: String = "--- Day 11: Reactor ---"

  init(data: String) {
    adjacency = try! Self.InputParser().parse(data)
  }

  func part1() async throws -> Int {
    countPathsStartingAt("you")
  }
}

extension Day11 {
  func countPathsStartingAt(_ start: String) -> Int {
    var queue: Deque<String> = [start]
    var count = 0

    while let current = queue.popFirst() {
      switch current {
      case "out":
        count += 1
      case let next:
        for neighbour in adjacency[next, default: []] {
          queue.append(neighbour)
        }
      }
    }
    return count
  }
}

// Parsing
extension Day11 {
  struct InputParser: Parser {
    var body: some Parser<Substring, [String: [String]]> {
      Many {
        Parse {
          Prefix(3).map(String.init)
          ":"
          Many {
            " "
            Prefix(3).map(String.init)
          }
        }
      } separator: {
        "\n"
      } terminator: {
        End()
      }.map { parsed in
        parsed.reduce(into: [String: [String]]()) {
          $0[$1.0, default: []] = $1.1
        }
      }
    }
  }
}
