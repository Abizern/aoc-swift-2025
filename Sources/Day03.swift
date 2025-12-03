import AoCCommon
import Foundation

struct Day03: AdventDay, Sendable {
  let banks: [[Int]]
  let day = 3
  let puzzleName: String = "--- Day 3: Lobby ---"

  init(data: String) {
    banks = try! SingleDigitLinesParser().parse(data)
  }

  // Replace this with your solution for the first part of the day's challenge.
  func part1() async throws -> Int {
    banks.map(largestNumber).reduce(into: 0, +=)
  }
}

// Add any extra code and types in here to separate it from the required behaviour
extension Day03 {
  func largestNumber(_ numbers: [Int]) -> Int {
    let leading = numbers.dropLast()
    let last = numbers.last!

    var (tens, units) = leading.reduce(into: (0, 0)) { accumulator, n in
      switch (accumulator, n) {
      case let ((0, _), n):
        accumulator = (n, 0)
      case let ((a, _), n) where n > a:
        accumulator = (n, 0)
      case let ((a, b), n) where n > b:
        accumulator = (a, n)
      default:
        break
      }
    }

    units = max(units, last)
    return tens * 10 + units
  }


}
