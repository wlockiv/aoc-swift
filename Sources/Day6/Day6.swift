import Algorithms

func firstWindowWithUniqueChars(str: String, size: UInt) -> UInt? {
    for idx in 0..<str.count {
        if idx < size {
            continue
        }
        
        let endOfWindow = str.index(str.startIndex, offsetBy: idx)
        let startOfWindow = str.index(endOfWindow, offsetBy: -Int(size))
        let thisString = str[startOfWindow..<endOfWindow]
        
        if Array(thisString.uniqued()).count == size {
            return UInt(idx)
        }
    }
    
    return nil
}

public func partOne() {
    let answer = firstWindowWithUniqueChars(str: input, size: 4)!
    
    print("Day 06, Part 1 :: \(answer)")
}

public func partTwo() {
    let answer = firstWindowWithUniqueChars(str: input, size: 14)!
    
    print("Day 06, Part 2 :: \(answer)")

}
