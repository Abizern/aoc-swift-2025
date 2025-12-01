import AoCCommon
import Foundation

struct Day01: AdventDay, Sendable {
  let turns: [Turn]
  let day = 1
  let puzzleName: String = "--- Day 1: Secret Entrance ---"

  init(data: String) {
    do {
      turns = try data
        .lines()
        .map(Turn.init)
    } catch {
      fatalError("\(error)")
    }
  }

  func part1() async throws -> Int {
    var position = 50
    var result = 0

    for turn in turns {
      switch turn {
      case .left(let val):
        position = mod(position - val, 100)
      case .right(let val):
        position = mod(position + val, 100)
      }

      if position == 0 {
        result += 1
      }
    }

    return result
  }

  func part2() async throws -> Int {
    var position = 50
    var result = 0

    for turn in turns {
      switch (turn, position) {
      case (.left(let val), 0):
        result += val / 100
        position = mod(position - val, 100)
      case (.right(let val), 0):
        result += val / 100
        position = mod(position + val, 100)
      case (.left(let val), _):
        result += val / 100
        let newPosition = mod(position - val, 100)
        if newPosition == 0 {
          result += 1
        } else if newPosition > position {
          result += 1
        }
        position = newPosition
      case (.right(let val), _):
        result += val / 100
        let newPosition = mod(position + val, 100)
        if newPosition == 0 {
          result += 1
        } else if newPosition < position {
          result += 1
        }
        position = newPosition
      }
    }

    return result
  }
}

extension Day01 {
  enum Turn: Sendable {
    case left(Int)
    case right(Int)

    init(_ string: String) {
      let str = string[...]
      guard
        let dir = str.first,
        let distance = Int(str.dropFirst())
      else { fatalError("\(string) is not a valid turn") }

      switch dir {
      case Character("L"): self = .left(distance)
      case Character("R"): self = .right(distance)
      default: fatalError("\(dir) is not a valid direction")
      }
    }
  }
}
