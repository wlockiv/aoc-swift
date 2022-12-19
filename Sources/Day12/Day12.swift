
public func partOne() {
    let heightMap = makeHeightMap(rawInput: input)
    let (graph, markers) = makeGraph(rawInput: input, markerChars: ["S", "E"])
    
    let (shortestPath, _) = findShortestPaths(
        graph: graph,
        start: markers["S"]!,
        pathInvalidator: { heightMap[$0]! - heightMap[$1]! > 1 }
    )

    let answer = shortestPath[markers["E"]!]!
    
    print("Day 12, Part 1 :: \(answer)")
}

public func partTwo() {
    let heightMap = makeHeightMap(rawInput: input)
    let (graph, markers) = makeGraph(rawInput: input, markerChars: ["S", "E"])
    
    let (shortestPath, _) = findShortestPaths(
        graph: graph,
        start: markers["E"]!,
        pathInvalidator: { heightMap[$0]! - heightMap[$1]! < -1 }
    )
    
    let allAs = heightMap.filter({ $0.value == Int(exactly: Character("a").asciiValue!) })
    let answer = shortestPath.filter({ allAs.keys.contains($0.key) }).min(by: { $0.value < $1.value })!.value
    
    print("Day 12, Part 2 :: \(answer)")
}

fileprivate struct Coordinate: Hashable {
    var x: Int
    var y: Int
    
    init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }
}

/// Path finder adapted from Djiksta's path finding algo
fileprivate func findShortestPaths(
    graph: [Coordinate: [Coordinate]],
    start: Coordinate,
    pathInvalidator: (Coordinate, Coordinate) -> Bool
) -> (shortesDistances: [Coordinate: Int], previousNodes: [Coordinate: Coordinate]) {
    var unvisited = Set(graph.keys)
    var shortestPath: [Coordinate: Int] = [:]
    var previousNodes: [Coordinate: Coordinate] = [:]
    
    for node in unvisited {
        shortestPath[node] = Int.max - 1
    }
    shortestPath[start] = 0
    
    while !unvisited.isEmpty {
        var currentMinNode: Coordinate? = nil
        for node in unvisited {
            if currentMinNode == nil {
                currentMinNode = node
            }
            
            if shortestPath[node]! < shortestPath[currentMinNode!]! {
                currentMinNode = node
            }
        }
        
        for neighbor in graph[currentMinNode!]! {
            if pathInvalidator(neighbor, currentMinNode!) {
                continue
            }
            
            let tmpValue = shortestPath[currentMinNode!]! + 1
            if tmpValue < shortestPath[neighbor]! {
                shortestPath[neighbor] = tmpValue
                previousNodes[neighbor] = currentMinNode
            }
        }
        
        unvisited.remove(currentMinNode!)
    }
    
    return (shortestPath, previousNodes)
}

fileprivate func makeHeightMap(rawInput: String) -> [Coordinate: Int] {
    let inputLines = rawInput.split(separator: "\n")
    var heightMap: [Coordinate: Int] = [:]
    
    for (y, line) in inputLines.enumerated() {
        for (x, rawChar) in line.enumerated() {
            var char: Character = rawChar
            if rawChar == "S" {
                char = "a"
            } else if rawChar == "E" {
                char = "z"
            }
            
            let height = Int(exactly: char.asciiValue!)!
            heightMap[Coordinate(x, y)] = height
        }
    }
    
    return heightMap
}

fileprivate func makeGraph(rawInput: String, markerChars: [Character]) -> (graph: [Coordinate: [Coordinate]], markers: [Character: Coordinate]) {
    let inputLines = rawInput.split(separator: "\n")
    let xMax = inputLines[0].count - 1
    let yMax = inputLines.count - 1
    
    var graph: [Coordinate: [Coordinate]] = [:]
    var markers: [Character: Coordinate] = [:]
    
    for (y, line) in inputLines.enumerated() {
        for (x, char) in line.enumerated() {
            let coord = Coordinate(x, y)
            if markerChars.contains(char) {
                markers[char] = coord
            }
            
            graph[coord] = getNeighbors(coord: coord, xMax: xMax, yMax: yMax)
        }
    }
    
    return (graph, markers)
}

fileprivate func getNeighbors(coord: Coordinate, xMax: Int, yMax: Int) -> [Coordinate] {
    /// up, right, down, left
    let offsets = [(0, -1), (1, 0), (0, 1), (-1, 0)]
    var neighbors: [Coordinate] = []
    
    for offset in offsets {
        let newX = coord.x + offset.0
        let newY = coord.y + offset.1
        
        if newX < 0 || newY < 0 {
            continue
        }
        
        if newX > xMax || newY > yMax {
            continue
        }
        
        neighbors.append(Coordinate(newX, newY))
    }
    
    return neighbors
}
