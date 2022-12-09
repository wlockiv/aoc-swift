import Algorithms

struct CoverageArea {
    let leftBound: UInt
    let rightBound: UInt
    let range: ClosedRange<UInt>
    
    init(leftBound: UInt, rightBound: UInt) {
        self.leftBound = leftBound
        self.rightBound = rightBound
        self.range = leftBound...rightBound
    }
    
    static func fromString(input: String) -> CoverageArea {
        let split = input.split(separator: "-")
        return CoverageArea(leftBound: UInt(split[0])!, rightBound: UInt(split[1])!)
    }
    
    func contains(other areaToCompare: CoverageArea) -> Bool {
        self.leftBound <= areaToCompare.leftBound && self.rightBound >= areaToCompare.rightBound
    }
    
    func overlaps(with areaToCompare: CoverageArea) -> Bool {
        /**
         * Found out this also works just as well:
         * `self.range.overlaps(areaToCompare.range)`
         *  `overlaps` is a method on `Range`
         */
        
        if self.range ~= areaToCompare.leftBound {
            return true
        }
        
        if self.range ~= areaToCompare.rightBound {
            return true
        }
        
        if areaToCompare.range ~= self.leftBound {
            return true
        }
        
        if areaToCompare.range ~= self.rightBound {
            return true
        }
        
        return false
    }
}


public func partOne() {
    // [[aLeft-aRight], [bLeft-bRight], ...]
    let teamAssignments = input.split(separator: "\n").map({ $0.split(separator: ",")})

    var count = 0
    for pairs in teamAssignments {
        let elfXAssignment = CoverageArea.fromString(input: String(pairs[0]))
        let elfYAssignment = CoverageArea.fromString(input: String(pairs[1]))
        
        if elfXAssignment.contains(other: elfYAssignment) {
            count += 1
        } else if elfYAssignment.contains(other: elfXAssignment) {
            count += 1
        }
    }
    
    print("Day 04, Part 1 :: \(count)")
}

public func partTwo() {
    let teamAssignments = input.split(separator: "\n").map({ $0.split(separator: ",")})

    var count = 0
    for pairs in teamAssignments {
        let elfXAssignment = CoverageArea.fromString(input: String(pairs[0]))
        let elfYAssignment = CoverageArea.fromString(input: String(pairs[1]))
        
        if elfXAssignment.overlaps(with: elfYAssignment) {
            count += 1
        }
    }
    
    print("Day 04, Part 2 :: \(count)")
}
