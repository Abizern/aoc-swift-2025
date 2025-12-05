import AoCCommon
import Foundation

struct Day05: AdventDay, Sendable {
  let ranges: [ClosedRange<Int>]
  let ids: [Int]
  let day = 5
  let puzzleName: String = "--- Day 5: Cafeteria ---"

  init(data: String) {
    let (ranges, ids) = try! InputParser().parse(data)
    self.ranges = ranges.map(Day05.makeRange)
    self.ids = ids
  }

  func part1() async throws -> Int {
    var result = 0
    for id in ids {
      for range in ranges {
        if range.contains(id) {
          result += 1
          break
        }
      }
    }
    return result
  }

  func part2() async throws -> Int {
    ranges
      .merged()
      .reduce(into: 0) { $0 += $1.upperBound - $1.lowerBound + 1 }
  }
}

extension Day05 {
  static func makeRange(_ pair: (Int, Int)) -> ClosedRange<Int> {
    min(pair.0, pair.1) ... max(pair.0, pair.1)
  }
}

// Parsing
extension Day05 {
  struct InputParser: Parser {
    var body: some Parser<Substring, ([(Int, Int)], [Int])> {
      Parse {
        NumberRangeLines()
        "\n\n"
        Parse {
          Many {
            Digits()
          } separator: {
            "\n"
          } terminator: {
            End()
          }
        }
      }
    }
  }
}
