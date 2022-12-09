import Algorithms

private func letterToValue(letter: Character) -> UInt8 {
    let asciiValue = letter.asciiValue!
    
    let lowerCaseRange = Character("a").asciiValue!...Character("z").asciiValue!
    if lowerCaseRange.contains(asciiValue) {
        return asciiValue - 96
    }
    
    return asciiValue - 38
}

public func partOne() {
    let lines = input.split(separator: "\n")
    
    var sum: UInt = 0
    for line in lines {
        let startIdx = line.startIndex
        let halfIdx = line.index(line.startIndex, offsetBy: line.count / 2)
        let (firstHalf, lastHalf) = (line[startIdx..<halfIdx], line[halfIdx...])
        let repeatedItem = firstHalf.first(where: { lastHalf.contains($0) })!
        
        sum = sum + UInt(letterToValue(letter: repeatedItem))
    }

    print("Day 03, Part 1 :: \(sum)")
}

public func partTwo() {
    let elfChunks = input.split(separator: "\n").chunks(ofCount: 3)
    
    var sum: UInt = 0
    for chunk in elfChunks {
        var chunkIter = chunk.makeIterator()
        let (a, b, c) = (chunkIter.next()!, chunkIter.next()!, chunkIter.next()!)
        let commonItem = a.first(where: { b.contains($0) && c.contains($0) })!
        
        sum += UInt(letterToValue(letter: commonItem))
    }
    
    print("Day 03, Part 2 :: \(sum)")
}
