import Testing

@testable import AdventOfCode

@Suite("Day08 Tests")
struct Day08Tests {
  @Suite("Tests on sample inputs")
  struct SolutionsTests {
    let day = Day08(data: testInput)

    @Test("Part1 example")
    func part1() async throws {
      let pairs = day.closestPairs.prefix(10)
      let result = day.chainSizeList(pairs).prefix(3).reduce(into: 1, *=)
      #expect(result == 40)
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
  162,817,812
  57,618,57
  906,360,560
  592,479,940
  352,342,300
  466,668,158
  542,29,236
  431,825,988
  739,650,466
  52,470,668
  216,146,977
  819,987,18
  117,168,530
  805,96,715
  346,949,466
  970,615,88
  941,993,340
  862,61,35
  984,92,344
  425,690,689
  """
