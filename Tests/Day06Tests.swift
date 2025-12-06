import Testing

@testable import AdventOfCode

@Suite("Day06 Tests")
struct Day06Tests {
  @Suite("Parser Tests")
  struct ParserTests {
    @Test("Test parser implementation")
    func parseInput() {
      let day = Day06(data: testInput)
      #expect(day.digitLines.count == 3)
      #expect(day.digitLines.first?.count == 4)
      #expect(day.operations == [.multiply, .add, .multiply, .add])
    }
  }

  @Suite("Tests on sample inputs")
  struct SolutionsTests {
    let day = Day06(data: testInput)

    @Test("Part1 example")
    func testPart1() async throws {
      let result = try await day.part1()
      #expect(result == 4_277_556)
    }

    @Test("Part2 example")
    func testPart2() async throws {
      let result = try await day.part2()
      #expect(result == 3_263_827)
    }
  }
}

private let testInput =
  """
  123 328  51 64 
   45 64  387 23 
    6 98  215 314
  *   +   *   +  
  """
