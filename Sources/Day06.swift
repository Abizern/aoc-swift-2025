import AoCCommon
import Foundation

struct Day06: AdventDay, Sendable {
  let inputs: [[Int]]
  let operators: [Character]
  let day = 6
  let puzzleName: String = "--- Day 6: Trash Compactor ---"

  init(data: String) {
    let (numbers, operators) = try! Self.parseInput(data.lines())
    inputs = numbers
    self.operators = operators
  }

  func part1() async throws -> Int {
    var accumulator = 0
    for index in 0 ..< inputs.count {
      let line = inputs[index]
      let operation = operation(operators[index])
      accumulator += operation(line)
    }

    return accumulator
  }
}

extension Day06 {
  func operation(_ c: Character) -> ([Int]) -> Int {
    switch c {
    case "+":
      { line in line.reduce(into: 0, +=) }
    case "*":
      { line in line.reduce(into: 1, *=) }
    default:
      fatalError("Unexpected operator: \(c)")
    }
  }
}

// Parsing
extension Day06 {
  static func parseLine(_ line: String) -> [String] {
    line.matches(of: /(\d+|[+*])/).map { String($0.1) }
  }

  static func parseNumbers(_ line: String) -> [Int] {
    parseLine(line).compactMap(Int.init)
  }

  static func parseOperators(_ line: String) -> [Character] {
    parseLine(line).compactMap(\.first)
  }

  static func transpose(_ lines: [[Int]]) -> [[Int]] {
    let first = lines.first!
    return (0 ..< first.count).map { col in
      lines.map { $0[col] }
    }
  }

  static func parseInput(_ lines: [String]) -> ([[Int]], [Character]) {
    (transpose(lines.dropLast().map(parseNumbers)),
     parseOperators(lines.last!))
  }
}
