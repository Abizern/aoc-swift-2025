import Algorithms
import Foundation

struct Day02: AdventDay, Sendable {
  let ranges: [(Int, Int)]
  let day = 2
  let puzzleName: String = "--- Day 2: Gift Shop ---"

  init(data: String) {
    ranges = try! data.numberRanges()
  }

  func part1() async throws -> Int {
    ranges
      .flatMap { invalidIDs(in: $0, predicate: hasEqualHalves) }
      .reduce(into: 0, +=)
  }

  func part2() async throws -> Int {
    ranges
      .flatMap { invalidIDs(in: $0, predicate: hasRepeatedSequence) }
      .reduce(into: 0, +=)
  }
}

extension Day02 {
  func hasEqualHalves(_ number: Int) -> Bool {
    let str = String(number)
    guard str.count % 2 == 0 else { return false }

    let mid = str.count / 2
    let start = str.prefix(mid)
    let end = str.suffix(mid)

    return start == end
  }

  func hasRepeatedSequence(_ number: Int) -> Bool {
    let str = String(number)
    let length = str.count
    guard length >= 2 else { return false }

    for size in 2 ... length {
      if length % size == 0,
         Set(str.chunks(ofCount: length / size)).count == 1
      {
        return true
      }
    }

    return false
  }

  func invalidIDs(in rng: (Int, Int), predicate: (Int) -> Bool) -> [Int] {
    var accumulator: [Int] = []

    let start = rng.0
    let end = rng.1

    for i in start ... end {
      if predicate(i) {
        accumulator.append(i)
      }
    }

    return accumulator
  }
}
