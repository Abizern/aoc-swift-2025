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

  func part2() async throws -> Int {
    var timelines: [Cell: Int] = [startCell: 1]

    for _ in startCell.row ..< grid.height - 1 {
      var newTimelines: [Cell: Int] = [:]
      for (beam, count) in timelines {
        let newBeam = beam.offset(by: .down)
        if grid[newBeam] == "." {
          newTimelines[newBeam, default: 0] += count
        } else {
          newTimelines[newBeam.offset(by: .left), default: 0] += count
          newTimelines[newBeam.offset(by: .right), default: 0] += count
        }
      }
      timelines = newTimelines
    }

    return timelines.values.reduce(into: 0, +=)
  }
}
