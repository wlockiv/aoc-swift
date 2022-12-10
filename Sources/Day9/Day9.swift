import Algorithms
import Foundation



public func partOne() {
    let instructions = makeInstructions(input)
    var coordH = Coordinate(0, 0)
    var coordT = Coordinate(0, 0)
    var coordHLast = Coordinate(0, 0)
    var visited: Set<Coordinate> = Set([coordT])
    
    for instruction in instructions {
        coordHLast = coordH
        
        coordH.move(direction: instruction)
        
        let distance = getDistance(from: coordH, to: coordT)
        
        if distance >= 2 {
            coordT = coordHLast
            visited.insert(coordT)
        }
    }
    
    let answer = visited.count
    print("Day 09, Part 1 :: \(answer)")
}


public func partTwo() {
    let instructions = makeInstructions(input)

    let knotCount = 10
    var coords = Array(repeating: Coordinate(0, 0), count: knotCount)
    
    var visited: Set<Coordinate> = Set([coords.last!])
    for instruction in instructions {
        coords[0].move(direction: instruction)
        
        for idx in 1..<coords.count {
            let dX = coords[idx-1].x - coords[idx].x
            let dY = coords[idx-1].y - coords[idx].y
            
            if abs(dX) >= 2 && abs(dY) >= 2 {
                let newCoord = Coordinate(
                    coords[idx].x + dX / 2,
                    coords[idx].y + dY / 2
                )
                coords[idx] = newCoord
                continue
            }
            
            if abs(dX) == 2 {
                let newCoord = Coordinate(coords[idx].x + dX / 2, coords[idx].y + dY)
                coords[idx] = newCoord
            }

            if abs(dY) == 2 {
                let newCoord = Coordinate(coords[idx].x + dX, coords[idx].y + dY / 2)
                coords[idx] = newCoord
            }
        }
        visited.insert(coords.last!)
    }
    
    let answer = visited.count
    print("Day 09, Part 2 :: \(answer)")
}

fileprivate func makeInstructions(_ rawInput: String) -> [Character] {
    var instructions: [Character] = []
    
    for line in rawInput.split(separator: "\n") {
        let splitLine = line.split(separator: " ")
        let direction = splitLine[0].first!
        let distance = Int(splitLine[1])!
        
        instructions.append(contentsOf: Array(repeating: direction, count: distance))
    }
    
    return instructions
}


fileprivate func getDistance(from coordA: Coordinate, to coordB: Coordinate) -> Double {
    let dX = Double(coordB.x - coordA.x)
    let dY = Double(coordB.y - coordA.y)
    
    return hypot(dX, dY)
}

fileprivate struct Coordinate: Hashable {
    var x: Int
    var y: Int
    
    init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }
    
    mutating func move(direction: Character) {
        if direction == "U" {
            self.y += 1
        }
        
        if direction == "R" {
            self.x += 1
        }
        
        if direction == "D" {
            self.y -= 1
        }
        
        if direction == "L" {
            self.x -= 1
        }
    }
}
