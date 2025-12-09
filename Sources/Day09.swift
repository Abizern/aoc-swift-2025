import AoCCommon
import Foundation

struct Day09: AdventDay, Sendable {
  let tiles: [Cell]
  let day = 9
  let edges: [(Cell, Cell)]
  let puzzleName: String = "--- Day 9: Movie Theater ---"

  init(data: String) {
    tiles = try! NumberPairs(separator: ",", transform: Cell.init).parse(data)
    edges = zip(tiles, tiles.dropFirst()) + [(tiles.last!, tiles.first!)]
  }

  func part1() async throws -> UInt {
    areas(tiles).max()!
  }

  func part2() async throws -> UInt {
    var best: UInt = 0

    var i = 0
    while i < tiles.count {
      var j = i + 1
      while j < tiles.count {
        let a = tiles[i]
        let b = tiles[j]

        let candidateArea = area(a, b)
        if candidateArea > best,
           isValidRectangle(a, b, edges: edges)
        {
          best = candidateArea
        }

        j += 1
      }
      i += 1
    }

    return best
  }
}

extension Day09 {
  struct Rect: Equatable {
    let x1: Int
    let x2: Int
    let y1: Int
    let y2: Int
  }

  func rect(from a: Cell, _ b: Cell) -> Rect {
    let x1 = min(a.col, b.col)
    let x2 = max(a.col, b.col)
    let y1 = min(a.row, b.row)
    let y2 = max(a.row, b.row)
    return Rect(x1: x1, x2: x2, y1: y1, y2: y2)
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

  func isPointInPolygon(x: Double, y: Double, tiles: [Cell]) -> Bool {
    var inside = false
    var j = tiles.count - 1

    for i in 0 ..< tiles.count {
      let xi = Double(tiles[i].col)
      let yi = Double(tiles[i].row)
      let xj = Double(tiles[j].col)
      let yj = Double(tiles[j].row)

      let intersects = ((yi > y) != (yj > y)) &&
        (x < (xj - xi) * (y - yi) / (yj - yi) + xi)

      if intersects {
        inside.toggle()
      }

      j = i
    }

    return inside
  }

  func isRectangleAreaCutByEdges(_ rect: Rect, edges: [(Cell, Cell)]) -> Bool {
    for (a, b) in edges {
      if a.col == b.col {
        let vx = a.col
        if rect.x1 < vx, vx < rect.x2 {
          let ey1 = min(a.row, b.row)
          let ey2 = max(a.row, b.row)
          if max(ey1, rect.y1) < min(ey2, rect.y2) {
            return true
          }
        }
      } else {
        let hy = a.row
        if rect.y1 < hy, hy < rect.y2 {
          let ex1 = min(a.col, b.col)
          let ex2 = max(a.col, b.col)
          if max(ex1, rect.x1) < min(ex2, rect.x2) {
            return true
          }
        }
      }
    }
    return false
  }

  func isValidRectangle(_ a: Cell, _ b: Cell, edges: [(Cell, Cell)]) -> Bool {
    let rect = rect(from: a, b)

    if isRectangleAreaCutByEdges(rect, edges: edges) {
      return false
    }

    let cx = Double(rect.x1 + rect.x2) / 2.0
    let cy = Double(rect.y1 + rect.y2) / 2.0

    return isPointInPolygon(x: cx, y: cy, tiles: tiles)
  }
}
