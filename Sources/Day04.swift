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
    let newGrid = remmoveRolls(from: grid)
    return grid.numberOfRolls - newGrid.numberOfRolls
  }

  func part2() async throws -> Int {
    var start = grid
    var mutated = remmoveRolls(from: grid)

    repeat {
      start = mutated
      mutated = remmoveRolls(from: start)
    } while mutated != start

    return grid.numberOfRolls - mutated.numberOfRolls
  }
}

extension Day04 {
  func isRoll(_ char: Character) -> Bool {
    char == "@"
  }

  func remmoveRolls(from grid: Grid<Character>) -> Grid<Character> {
    var rows = [[Character]]()
    for r in 0 ..< grid.height {
      var row = [Character](repeating: ".", count: grid.width)
      for c in 0 ..< grid.width {
        let cell = Cell(r, c)
        if grid[cell]!.isRoll,
           grid.neighbours(cell).map({ grid[$0]! }).count(where: \.isRoll) >= 4
        {
          row[c] = "@"
        }
      }
      rows.append(row)
    }

    return Grid(rows: rows)
  }
}

private extension Character {
  var isRoll: Bool { self == "@" }
}

private extension Grid where Element == Character {
  var numberOfRolls: Int {
    cells(where: \.isRoll).count
  }
}
