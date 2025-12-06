import AoCCommon
import Foundation

struct Day06: AdventDay, Sendable {
  let operations: [Operation]
  let digitLines: [[[Character]]]
  let day = 6
  let puzzleName: String = "--- Day 6: Trash Compactor ---"

  init(data: String) {
    let lines = try! data.characterLines()
    let ranges = Self.parseRanges(lines)

    var operations = [Operation]()
    for range in ranges {
      let line = lines.last!
      let idx = range.lowerBound
      let char = line[idx]
      operations.append(Operation(char))
    }

    var digitLines: [[[Character]]] = []
    for row in 0 ..< lines.count - 1 {
      var accumulator = [[Character]]()
      let line = lines[row]
      for range in ranges {
        accumulator.append(Array(line[range]))
      }
      digitLines.append(accumulator)
    }

    self.digitLines = digitLines
    self.operations = operations
  }

  func part1() async throws -> Int {
    let transposed: [[[Character]]] = transpose(digitLines)
    let argumentLines = transposed.map { line in
      line.compactMap { chars in
        Int(String(chars).trimmingCharacters(in: .whitespacesAndNewlines))
      }
    }

    var accumulator = 0
    for idx in 0 ..< operations.count {
      accumulator += operations[idx].apply(to: argumentLines[idx])
    }

    return accumulator
  }

  func part2() async throws -> Int {
    var newLines = [[[Character]]]()

    for index in 0 ..< digitLines.first!.count {
      var accumulatorr = [[Character]]()
      for line in digitLines {
        accumulatorr.append(line[index])
      }
      newLines.append(accumulatorr)
    }

    let blocks = newLines.map(transpose)

    let cephNumbers = blocks.map { (chars: [[Character]]) in
      chars.compactMap { (cs: [Character]) in
        Int(String(cs).trimmingCharacters(in: .whitespacesAndNewlines))
      }
    }

    var accumulator = 0
    for idx in 0 ..< operations.count {
      accumulator += operations[idx].apply(to: cephNumbers[idx])
    }

    return accumulator
  }
}

extension Day06 {
  enum Operation: Equatable {
    case add
    case multiply

    init(_ c: Character) {
      switch c {
      case "+":
        self = .add
      case "*":
        self = .multiply
      default:
        fatalError("Unexpected operator: \(c)")
      }
    }

    func apply(to list: [Int]) -> Int {
      switch self {
      case .add:
        list.reduce(into: 0, +=)
      case .multiply:
        list.reduce(into: 1, *=)
      }
    }
  }
}

// Parsing
extension Day06 {
  static func parseRanges(_ lines: [[Character]]) -> [Range<Int>] {
    let characters = lines.last!
    var indexes = [Int]()
    for (idx, character) in characters.enumerated() {
      if character != " " {
        indexes.append(idx)
      }
    }
    indexes.append(characters.count)

    return indexes.windows(ofCount: 2).map { $0.first! ..< $0.last! }
  }
}
