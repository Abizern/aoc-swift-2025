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
    var memo: [String: Int] = [:]
    return countSimplePaths("you", &memo)
  }

  func part2() async throws -> Int {
    countValidPaths()
  }
}

extension Day11 {
  func countSimplePaths(_ node: String, _ memo: inout [String: Int]) -> Int {
    if let cached = memo[node] {
      return cached
    }

    if node == "out" {
      memo[node] = 1
    }

    var total = 0
    for neighbour in adjacency[node, default: []] {
      total += countSimplePaths(neighbour, &memo)
    }

    memo[node] = total
    return total
  }

  private struct State: Hashable {
    let node: String
    let mask: Int
  }

  func countValidPaths() -> Int {
    var memo: [State: Int] = [:]
    let start = "svr"
    return countPaths(
      from: start,
      mask: 0,
      memo: &memo,
    )
  }

  private func countPaths(
    from node: String,
    mask: Int,
    memo: inout [State: Int],
  ) -> Int {
    var newMask = mask
    if node == "dac" { newMask |= 1 }
    if node == "fft" { newMask |= 2 }

    let state = State(node: node, mask: newMask)
    if let cached = memo[state] {
      return cached
    }

    if node == "out" {
      let result = (newMask == 3) ? 1 : 0
      memo[state] = result
      return result
    }

    var total = 0
    for neighbour in adjacency[node, default: []] {
      total += countPaths(
        from: neighbour,
        mask: newMask,
        memo: &memo,
      )
    }

    memo[state] = total
    return total
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
