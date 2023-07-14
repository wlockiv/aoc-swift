import Algorithms
import Foundation

enum Value {
    case num(Int)
    case arr([Value])
}

extension Value: Decodable {
    init(from decoder: Decoder) throws {
        do {
            let c = try decoder.singleValueContainer()
            self = .num(try c.decode(Int.self))
        } catch {
            self = .arr(try [Value](from: decoder))
        }
    }
}

extension Value: Comparable {
    static func < (lhs: Value, rhs: Value) -> Bool {
        switch (lhs, rhs) {
        case (.num(let i1), .num(let i2)):
            return i1 < i2
        case (.arr, .num):
            return lhs < .arr([rhs])
        case (.num, .arr):
            return .arr([lhs]) < rhs
        case (.arr(let l1), .arr(let l2)):
            for zipped in zip(l1, l2) {
                if zipped.0 < zipped.1 { return true }
                if zipped.0 > zipped.1 { return false }
            }
            return l1.count < l2.count
        }
    }
}

public func partOne() {
    let stringPairs = input
        .split(separator: "\n\n")
        .map({ $0.split(separator: "\n") })
    
    var answer = 0
    let decoder = JSONDecoder()
    for (idx, pair) in stringPairs.enumerated() {
        let leftSet = try! decoder.decode(Value.self, from: pair[0].data(using: .utf8)!)
        let rightSet = try! decoder.decode(Value.self, from: pair[1].data(using: .utf8)!)
        
        if leftSet < rightSet {
            answer += idx + 1
        }
    }
    
    print("Day 13, Part 1 :: \(answer)")
}

public func partTwo() {
    let rows = input.split(separator: /\n{1,2}/ )
    
    let decoder = JSONDecoder()
    
    let divPacket1 = try! decoder.decode(Value.self, from: "[[2]]".data(using: .utf8)!)
    let divPacket2 = try! decoder.decode(Value.self, from: "[[6]]".data(using: .utf8)!)
    
    var parsedRows = rows.map { row in
        try! decoder.decode(Value.self, from: row.data(using: .utf8)!)
    }
    
    parsedRows.append(contentsOf: [divPacket1, divPacket2])
    
    parsedRows.sort()
    
    let p1 = parsedRows.firstIndex(of: divPacket1)! + 1
    let p2 = parsedRows.firstIndex(of: divPacket2)! + 1
    
    print("Day 13, Part 2 :: \(p1 * p2)")
}
