import Testing

@testable import AdventOfCode

@Suite("Day10 Tests")
struct Day10Tests {
  @Suite("Parser Tests")
  struct ParserTests {
    @Test("Test Parsing a single machine")
    func singleMachine() throws {
      let machine = try Day10.MachineParser().parse(singleTestInput)
      #expect(machine.buttons == [.off, .on, .on, .off])
      #expect(machine.switches == [[3], [1, 3], [2], [2, 3], [0, 2], [0, 1]])
      #expect(machine.joltages == [3, 5, 4, 7])
    }

    @Test("Test parser implementation")
    func parseInput() {
      let day = Day10(data: testInput)
      #expect(day.machines.count == 3)
    }
  }

  @Suite("Tests on sample inputs")
  struct SolutionsTests {
    let day = Day10(data: testInput)

    @Test("Part1 example")
    func testPart1() async throws {
      await withKnownIssue {
        let result = try await day.part1()
        #expect(result == 10)
      }
    }

    @Test("Part2 example")
    func testPart2() async throws {
      await withKnownIssue {
        let result = try await day.part2()
        #expect(result == 10)
      }
    }
  }
}

private let testInput =
  """
  [.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}
  [...#.] (0,2,3,4) (2,3) (0,4) (0,1,2) (1,2,3,4) {7,5,12,7,2}
  [.###.#] (0,1,2,3,4) (0,3,4) (0,1,2,4,5) (1,2) {10,11,11,5,10,5}
  """

private let singleTestInput = "[.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}"
