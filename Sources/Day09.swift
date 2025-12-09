import AoCCommon
import Foundation

struct Day09: AdventDay, Sendable {
  let tiles: [Cell]
  let day = 9
  let puzzleName: String = "--- Day 9: Movie Theater ---"

  init(data: String) {
    tiles = try! NumberPairs(separator: ",", transform: Cell.init).parse(data)
  }

  func part1() async throws -> UInt {
    areas(tiles).max()!
  }
}

extension Day09 {
  func area(_ lhs: Cell, _ rhs: Cell) -> UInt {
    let width = (lhs.col - rhs.col).magnitude + 1
    let height = (lhs.row - rhs.row).magnitude + 1
    return width * height
  }

  func areas(_ tiles: [Cell]) -> [UInt] {
    var accumulator: [UInt] = []
    var corners = tiles[...]
    var start = corners.removeFirst()

    while corners.count > 0 {
      for corner in corners {
        accumulator.append(area(start, corner))
      }
      start = corners.removeFirst()
    }
    return accumulator
  }
}
