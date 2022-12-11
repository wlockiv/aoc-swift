import Algorithms

public func partOne() {
    let inputLines = input.split(separator: "\n")
    let ops = inputLines.map({ Operation(inputLine: $0) })
    
    var cycleCount = 0
    var registerX = 1
    var registerSnapshots = [20: 0, 60: 0, 100: 0, 140: 0, 180: 0, 220: 0]

    for operation in ops {
        for _ in 0..<operation.cycles {
            cycleCount += 1
            
            if registerSnapshots.keys.contains(cycleCount) {
                registerSnapshots[cycleCount] = registerX
            }
        }
        
        if case .add(let offest) = operation {
            registerX += offest
        }
    }
    
    let answer = registerSnapshots.reduce(0, { result, snapshot in
        result + (snapshot.key * snapshot.value)
    })
    print("Day 10, Part 1 :: \(answer)")
}

public func partTwo() {
    let inputLines = input.split(separator: "\n")
    let ops = inputLines.map({ Operation(inputLine: $0) })
    
    var registerX = 1
    
    var allRows: [String] = []
    var currentRow = ""
    for operation in ops {
        for _ in 0..<operation.cycles {
            if (registerX..<registerX+3).contains(currentRow.count + 1) {
                currentRow.append("#")
            } else {
                currentRow.append(" ")
            }
            
            if currentRow.count % 40 == 0 {
                allRows.append(currentRow)
                currentRow = ""
            }
        }
        
        if case .add(let offest) = operation {
            registerX += offest
        }
    }
    
    let answer = allRows.joined(separator: "\n")
    print("Day 10, Part 2 ::\n\(answer)")
}

enum Operation {
    case add(Int)
    case noop
    
    init(inputLine: some StringProtocol) {
        if inputLine.starts(with: "noop") {
            self = .noop
        } else {
            let splitLine = inputLine.split(separator: " ")
            self = .add(Int(splitLine[1])!)
        }
    }
    
    var cycles: Int {
        switch self {
        case .add:
            return 2
        case .noop:
            return 1
        }
    }
}
