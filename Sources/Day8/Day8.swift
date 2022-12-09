import Algorithms

fileprivate let (graph, boundaryTrees) = makeGraph(from: input)
fileprivate let steppers: [(Coordinate) -> Coordinate] = [stepUp, stepRight, stepDown, stepLeft]

public func partOne() {
    var visibleTrees: Set<Coordinate> = Set().union(boundaryTrees)
    
    for (currentCoord, currentTreeHeight) in graph {
        for stepper in steppers {
            if visibleTrees.contains(currentCoord) {
                break
            }
            
            var compCoord = stepper(currentCoord)
            
            while graph.keys.contains(compCoord) {
                let compTreeHeight = graph[compCoord]!
                
                if currentTreeHeight <= compTreeHeight {
                    break
                }
                
                if boundaryTrees.contains(compCoord) {
                    visibleTrees.insert(currentCoord)
                    break
                }
                
                compCoord = stepper(compCoord)
            }
        }
    }
    
    let answer = visibleTrees.count
    print("Day 08, Part 1 :: \(answer)")
}

public func partTwo() {
    var allScenicScores: [Int] = []
    for (currentCoord, currentTreeHeight) in graph {
        if boundaryTrees.contains(currentCoord) {
            continue
        }
        
        var scenicScores: [Int] = []
        for stepper in steppers {
            var compCoord = stepper(currentCoord)
            
            var visibleTrees = 0
            while graph.keys.contains(compCoord) {
                let compTreeHeight = graph[compCoord]!
                
                if currentTreeHeight <= compTreeHeight {
                    visibleTrees += 1
                    break
                }
                
                if boundaryTrees.contains(compCoord) {
                    visibleTrees += 1
                    break
                }
                
                compCoord = stepper(compCoord)
                visibleTrees += 1
            }
            
            scenicScores.append(visibleTrees)
        }
        allScenicScores.append(scenicScores.reduce(1, *))
    }
    
    let answer = allScenicScores.max()!
    print("Day 08, Part 2 :: \(answer)")
}

struct Coordinate: Hashable {
    let x: Int
    let y: Int
    
    init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }
}

fileprivate func makeGraph(from rawInput: String) -> ([Coordinate: Int], Set<Coordinate>) {
    let inputLines = input.split(separator: "\n")
    let yMax = inputLines.count - 1
    let xMax = inputLines[0].count - 1
    
    var graph: [Coordinate: Int] = [:]
    var boundaryTrees: Set<Coordinate> = Set()
    for (y, row) in inputLines.enumerated() {
        for (x, char) in row.enumerated() {
            let coord = Coordinate(x, y)
            graph[coord] = char.wholeNumberValue
            
            if isExternalTree(coord: coord, xMax: xMax, yMax: yMax) {
                boundaryTrees.insert(coord)
            }
        }
    }
    
    return (graph, boundaryTrees)
}

fileprivate func stepUp(from coord: Coordinate) -> Coordinate {
    return Coordinate(coord.x, coord.y - 1)
}

fileprivate func stepDown(from coord: Coordinate) -> Coordinate {
    return Coordinate(coord.x, coord.y + 1)
}

fileprivate func stepLeft(from coord: Coordinate) -> Coordinate {
    return Coordinate(coord.x - 1, coord.y)
}

fileprivate func stepRight(from coord: Coordinate) -> Coordinate {
    return Coordinate(coord.x + 1, coord.y)
}

fileprivate func isExternalTree(coord: Coordinate, xMax: Int, yMax: Int) -> Bool {
    if [coord.x, coord.y].contains(0) {
        return true
    }
    
    if coord.x == xMax || coord.y == yMax {
        return true
    }
    
    return false
}


