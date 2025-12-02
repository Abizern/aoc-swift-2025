import Foundation

struct Day02: AdventDay, Sendable {
  let ranges: [(Int, Int)]
  let day = 2
  let puzzleName: String = "--- Day 2: Gift Shop ---"

  init(data: String) {
    self.ranges = try! data.numberRanges()
  }

  func part1() async throws -> Int {
    return ranges.flatMap(invalidIDs).reduce(into: 0, +=)
  }

}

extension Day02 {
  func hasEqualHalves(_ number: Int) -> Bool {
    let str = String(number)
    guard str.count % 2 == 0 else { return false }

    let mid = str.count / 2
    let start = String(str.prefix(mid))
    let end = String(str.suffix(mid))

    return start == end
  }

  func invalidIDs(in rng: (Int, Int)) -> [Int] {
    var accumulator : [Int] = []

    let start = rng.0
    let end = rng.1

    for i in start...end {
      if hasEqualHalves(i) {
        accumulator.append(i)
      }
    }

    return accumulator
  }
}
