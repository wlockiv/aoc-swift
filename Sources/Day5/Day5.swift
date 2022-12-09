import Algorithms


func rawCratesInputToStackMap(rawCratesInput: some StringProtocol) -> [Int: [String]] {
    var rawCrateLines = rawCratesInput.split(separator: "\n")
    
    let colNumberLine = rawCrateLines.popLast()!
    let numStacks = Int(String(colNumberLine.max()!))!
    
    var result: [Int: [String]] = [:]
    for ns in 1...numStacks {
        result[ns] = []
    }
    
    for line in rawCrateLines {
        for (idx, chunk) in line.chunks(ofCount: 4).enumerated() {
            var chunkString = String(chunk)
            if chunkString.wholeMatch(of: /^\s+$/) != nil {
                continue
            }
            
            if chunkString.wholeMatch(of: /^\s\d\s{0,2}$/) != nil {
                continue
            }
            
            chunkString.trim(while: { $0 == " " })
            result[idx+1]!.insert(chunkString, at: 0)
        }
    }
    
    return result
}

struct Instruction {
    let from: Int
    let to: Int
    let num: Int
    
    init(from: Int, to: Int, num: Int) {
        self.from = from
        self.to = to
        self.num = num
    }
    
    static func fromString(from instructionString: Substring) -> Instruction {
        // move 1 from 2 to 1
        let matches = instructionString.matches(of: /\d+/)
        return Instruction(
            from: Int(matches[1].output)!,
            to: Int(matches[2].output)!,
            num: Int(matches[0].output)!
        )
    }
}


public func partOne() {
    let inputGroups = input.split(separator: "\n\n")
    var crateStacks = rawCratesInputToStackMap(rawCratesInput: inputGroups[0])
    let instructions = inputGroups[1]
        .split(separator: "\n")
        .map({ Instruction.fromString(from: $0) })
    
    for instruction in instructions {
        var fromStack = crateStacks[instruction.from]!
        var toStack = crateStacks[instruction.to]!
        
        let r = (fromStack.index(fromStack.endIndex, offsetBy: -instruction.num)...fromStack.endIndex-1).reversed()
        for _ in r {
            toStack.append(fromStack.popLast()!)
        }
        
        crateStacks[instruction.from]! = fromStack
        crateStacks[instruction.to]! = toStack
    }
    
    var answer = ""
    for i in 1...crateStacks.count {
        let lastCrateInStack = crateStacks[i]!.last
        answer += lastCrateInStack!.firstMatch(of: /[A-Z]/)!.output
    }
    
    print("Day 05, Part 1 :: \(answer)")
}

public func partTwo() {
    let inputGroups = input.split(separator: "\n\n")
    var crateStacks = rawCratesInputToStackMap(rawCratesInput: inputGroups[0])
    let instructions = inputGroups[1]
        .split(separator: "\n")
        .map({ Instruction.fromString(from: $0) })
    
    for instruction in instructions {
        let fromStack = crateStacks[instruction.from]!
        var toStack = crateStacks[instruction.to]!
        
        let extracted = fromStack[
            fromStack.index(fromStack.endIndex, offsetBy: -instruction.num)...
        ]
        
        toStack.append(contentsOf: extracted)

        crateStacks[instruction.from]! = Array(fromStack[
            ..<fromStack.index(fromStack.endIndex, offsetBy: -instruction.num)
        ])
        crateStacks[instruction.to]! = toStack
    }
    
    var answer = ""
    for i in 1...crateStacks.count {
        let lastCrateInStack = crateStacks[i]!.last
        answer += lastCrateInStack!.firstMatch(of: /[A-Z]/)!.output
    }
    
    print("Day 05, Part 2 :: \(answer)")

}
