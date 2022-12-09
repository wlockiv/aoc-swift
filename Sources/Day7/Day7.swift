import Algorithms



func getDirectorySizes(terminalLog: String) -> [Int] {
    let terminalLines = terminalLog.split(separator: "\n")
    
    var directoryStack: [String] = []
    var sizes: [String: Int] = [:]
    
    for line in terminalLines {
        if line == "$ cd .." {
            directoryStack.removeLast()
            continue
        }
        
        if line.starts(with: "$ cd") {
            let path = String(line.split(separator: " ").last!)
            directoryStack.append(path)
            continue
        }
        
        if let fileSize = line.firstMatch(of: /^\d+/)?.output {
            for idx in 0..<directoryStack.count {
                let thisPath = directoryStack[
                    directoryStack.startIndex...directoryStack.index(0, offsetBy: idx)
                ].joined(separator: "#")
                
                sizes[thisPath, default: 0] += Int(fileSize)!
            }
        }
    }
    
    return Array(sizes.values)
}

public func partOne() {
    let sizes = getDirectorySizes(terminalLog: input)
    
    let answer = sizes.filter({ $0 <= 100_000 }).reduce(0, +)
    
    print("Day 07, Part 1 :: \(answer)")
}

public func partTwo() {
    let totalSpace = 70_000_000
    let spaceRequired = 30_000_000
    
    let sizes = getDirectorySizes(terminalLog: input)
    let rootDirectorySize = sizes.max()!
    
    
    var answer = 0
    for size in sizes.sorted() {
        if (totalSpace - rootDirectorySize) + size >= spaceRequired {
            answer = size
            break
        }
    }
    
    print("Day 07, Part 2 :: \(answer)")
}
