import AoCCommon
import Foundation

struct Day04: AdventDay, Sendable {
  let grid: Grid<Character>
  let day = 4
  let puzzleName: String = "--- Day 4: Printing Department ---"

  init(data: String) {
    grid = try! Grid(rows: data.characterLines())
  }

  func part1() async throws -> Int {
    var count = 0
    for r in 0 ..< grid.height {
      for c in 0 ..< grid.width {
        let neighbors = grid.neighbours(Cell(r, c)).map { grid[$0]! }
        if grid[r, c] == "@",
           neighbors.count(where: { $0 == "@" }) < 4
        {
          count += 1
        }
      }
    }

    return count
  }
}

extension Day04 {}

// Add any specific code for parsing here
extension Day04 {}
