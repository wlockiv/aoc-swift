import Algorithms

private func sumGroups(input: String) -> [Int] {
    let groups = input.split(separator: "\n\n")
    
    var sums: [Int] = []
    for group in groups {
        let sum = group
            .split(separator: "\n")
            .map({ Int($0)! })
            .reduce(0, +)
        
        sums.append(sum)
    }
    
    return sums
}

public func partOne() {
    let sums = sumGroups(input: input)
    
    print("Day 01, Part 1 :: \(sums.max()!)")
}

public func partTwo() {
    let sums = sumGroups(input: input)
    let sumOfTopThree = sums.max(count: 3).reduce(0, +)
    
    print("Day 01, Part 2 :: \(sumOfTopThree)")
}
