import AoCCommon
import Foundation

struct Day07: AdventDay, Sendable {
  let data: String
  let grid: Grid<Character>
  let startCell: Cell
  let day = 7
  let puzzleName: String = "--- Day 7: Laboratories --- "

  init(data: String) {
    self.data = data
    grid = try! Grid(rows: data.characterLines())
    startCell = grid.firstCell(for: "S")!
  }

  func part1() async throws -> Int {
    0
  }
}

extension Day07 {}

// Parsing
extension Day07 {}
