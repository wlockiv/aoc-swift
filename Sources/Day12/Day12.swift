import Algorithms

public func partOne() {
    let graph = Graph(rawInput: input)
    let start = graph.start!
    let destination = graph.destination!
    var unvisited: Set<Coordinate> = Set(graph.graph.keys)
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
                continue
            }

            if shortestPath[node]! < shortestPath[currentMinNode!]! {
                currentMinNode = node
            }
        }

        for neighbor in graph.graph[currentMinNode!]! {
            var tmpValue = shortestPath[currentMinNode!]! + neighbor.cost
            if tmpValue < shortestPath[neighbor.coord]! {
                shortestPath[neighbor.coord] = tmpValue
                previousNodes[neighbor.coord] = currentMinNode
            }
        }

        unvisited.remove(currentMinNode!)
    }

    print(shortestPath[destination]!)
}

public func partTwo() {
    
}

fileprivate struct Graph {
    let xMax: Int
    let yMax: Int
    var graph: [Coordinate: [Edge]]
    var start: Coordinate?
    var destination: Coordinate?
    
    
    init(rawInput: String, maxStepUp: Int = 1) {
        let inputLines = rawInput.split(separator: "\n")
        self.xMax = inputLines[0].count - 1
        self.yMax = inputLines.count - 1
        
        var heightMap: [Coordinate: Int] = [:]
        for (y, inputLine) in rawInput.split(separator: "\n").enumerated() {
            for (x, char) in inputLine.enumerated() {
                let thisCoord = Coordinate(x, y)
                if char == "E" {
                    self.destination = thisCoord
                    let value = Int(exactly: Character("z").asciiValue!)!
                    heightMap[thisCoord] = value
                    continue
                }
                
                if char == "S" {
                    self.start = thisCoord
                    let value = Int(exactly: Character("a").asciiValue!)!
                    heightMap[thisCoord] = value
                    continue
                }
                    
                heightMap[thisCoord] = Int(exactly: char.asciiValue!)!
            }
        }
        
        var tmpGraph: [Coordinate: [Edge]] = [:]
        for (coord, height) in heightMap {
            let neighbors = Graph.getNeighborCoords(of: coord, xMax: self.xMax, yMax: self.yMax)
                        
            for neighbor in neighbors {
                let cost = heightMap[neighbor]! - height
                
                if cost <= maxStepUp {
                    /// Cost is statically 1 since height has no effect technically
                    let edge = Edge(coord: neighbor, cost: 1)
                    tmpGraph[coord, default: []].append(edge)
                }
            }
        }
        self.graph = tmpGraph
    }
    
    static func getNeighborCoords(of coord: Coordinate, xMax: Int, yMax: Int) -> [Coordinate] {
        var neighbors: [Coordinate] = []
        let neighborOffsets = [
            "up": (0, -1),
            "right": (1, 0),
            "down": (0, 1),
            "left": (-1, 0),
        ]
        
        for offset in neighborOffsets {
            let x = coord.x + offset.value.0
            let y = coord.y + offset.value.1
            
            if (0...xMax).contains(x) && (0...yMax).contains(y) {
                neighbors.append(Coordinate(x, y))
            }
        }
        
        return neighbors
    }
}

fileprivate struct Coordinate: Hashable {
    var x: Int
    var y: Int
    
    init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }
}

fileprivate struct Edge {
    let coord: Coordinate
    let cost: Int
}
