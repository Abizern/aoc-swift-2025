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
    var beams: Set<Cell> = [startCell]
    var count = 0

    for _ in startCell.row ..< grid.height - 1 {
      var accumulator = Set<Cell>()
      for beam in beams {
        let newBeam = beam.offset(by: .down)
        if grid[newBeam] == "." {
          accumulator.insert(newBeam)
        } else {
          count += 1
          accumulator.insert(newBeam.offset(by: .left))
          accumulator.insert(newBeam.offset(by: .right))
        }
      }
      beams = accumulator
    }
    return count
  }
}

extension Day07 {}

// Parsing
extension Day07 {}
