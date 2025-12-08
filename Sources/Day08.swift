import AoCCommon
import Collections
import Foundation

struct Day08: AdventDay, Sendable {
  let junctions: [Vector3D]
  let closestPairs: [(Vector3D, Vector3D)]
  let day = 8
  let puzzleName: String = "--- Day 8: Playground ---"

  init(data: String) {
    junctions = try! NumberLines().parse(data).map(Vector3D.init)
    closestPairs = Self.generateDistances(junctions)
      .sorted { $0.1 < $1.1 }
      .map(\.0)
  }

  func part1() async throws -> Int {
    let pairs = closestPairs.prefix(1000)
    let chainSizes = chainSizeList(pairs).prefix(3).reduce(into: 1, *=)

    return chainSizes
  }

  func part2() async throws -> Int {
    let n = junctions.count
    let pairs = closestPairs

    var start = 0
    var end = pairs.count - 1
    var lastIndex = end

    while start <= end {
      let mid = (start + end) / 2

      let sizes = chainSizeList(pairs.prefix(mid + 1))

      if let largest = sizes.first, largest == n {
        lastIndex = mid
        end = mid - 1
      } else {
        start = mid + 1
      }
    }

    let (a, b) = pairs[lastIndex]
    return a.x * b.x
  }
}

extension Day08 {
  static func generateDistances(_ junctions: [Vector3D]) -> [((Vector3D, Vector3D), Int)] {
    var accumulator: [((Vector3D, Vector3D), Int)] = []
    var tails = junctions[...]
    guard !tails.isEmpty else { return [] }

    var head = tails.removeFirst()

    while !tails.isEmpty {
      for tail in tails {
        accumulator.append(((head, tail), head.squaredDistanceTo(tail)))
      }
      head = tails.removeFirst()
    }

    return accumulator
  }

  func chainSizeList(_ pairs: Array<(Vector3D, Vector3D)>.SubSequence) -> [Int] {
    var adjacency = Dictionary(uniqueKeysWithValues: junctions.map { ($0, Set<Vector3D>()) })

    for (a, b) in pairs {
      adjacency[a, default: []].insert(b)
      adjacency[b, default: []].insert(a)
    }

    var visited: Set<Vector3D> = []
    var sizes: [Int] = []

    for junction in junctions {
      guard !visited.contains(junction) else { continue }

      var queue: Deque<Vector3D> = [junction]
      var currentSize = 0

      while let current = queue.popFirst() {
        // Skip if we queued this node multiple times
        guard !visited.contains(current) else { continue }

        visited.insert(current)
        currentSize += 1

        for connection in adjacency[current, default: []] {
          if !visited.contains(connection) {
            queue.append(connection)
          }
        }
      }

      sizes.append(currentSize)
    }

    return sizes.sorted(by: >)
  }
}

extension Day08 {
  struct Vector3D: Hashable, CustomStringConvertible {
    var description: String {
      "(\(x), \(y), \(z))"
    }

    let x: Int
    let y: Int
    let z: Int

    init(_ list: [Int]) {
      x = list[0]
      y = list[1]
      z = list[2]
    }

    func squaredDistanceTo(_ other: Vector3D) -> Int {
      let dx = x - other.x
      let dy = y - other.y
      let dz = z - other.z
      return dx * dx + dy * dy + dz * dz
    }
  }
}
