import AoCCommon
import Foundation

struct Day05: AdventDay, Sendable {
  let ranges: [Range]
  let ids: [Int]
  let day = 5
  let puzzleName: String = "--- Day 5: Cafeteria ---"

  init(data: String) {
    let (ranges, ids) = try! InputParser().parse(data)
    self.ranges = ranges.map(Range.init)
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
}

extension Day05 {
  struct Range: Sendable, Equatable {
    let lower: Int
    let upper: Int

    init(pair: (Int, Int)) {
      lower = min(pair.0, pair.1)
      upper = max(pair.0, pair.1)
    }

    func contains(_ id: Int) -> Bool {
      id >= lower && id <= upper
    }
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
