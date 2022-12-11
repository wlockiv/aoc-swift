import Algorithms

public func partOne(rounds: Int = 20, postInspectionDivisor: Int = 3) {
    let monkeys = parseInput(input: input)
    let answer = calculateMonkeyBusiness(monkeys: monkeys, rounds: 20)
    print("Day 11, Part 1 :: \(answer)")
}

public func partTwo() {
    let monkeys = parseInput(input: input)
    let answer = calculateMonkeyBusiness(monkeys: monkeys, rounds: 10000, reduceWorry: false)
    print("Day 11, Part 2 :: \(answer)")
}

func calculateMonkeyBusiness(monkeys: [Monkey], rounds: Int = 20, reduceWorry: Bool = true) -> Int {
    let modulus = monkeys.map({ $0.testDivisor }).reduce(1, *)
    
    for _ in 0..<rounds {
        for monkey in monkeys {
            let transfers = monkey.inspectInventory(reduceWorry: reduceWorry, worryModulus: modulus)
            
            for transfer in transfers {
                let nextMonkey = monkeys.first(where: { transfer.monkeyId == $0.id })!
                nextMonkey.addItem(item: transfer.itemValue)
            }
        }
    }
    
    let sortedByInspections = monkeys.sorted(by: { $0.inspectionCount > $1.inspectionCount })
    return sortedByInspections[0].inspectionCount * sortedByInspections[1].inspectionCount
}

fileprivate func parseInput(input: String) -> [Monkey] {
    let rawMonkeySpecs = input.split(separator: "\n\n")
    
    var monkeys: [Monkey] = []
    for spec in rawMonkeySpecs {
        let specLines = spec.split(separator: "\n")
        
        let id = Int(specLines[0].firstMatch(of: /\d+/)!.output)!
        
        let startingItems = specLines[1].matches(of: /\d+/).map({ Int($0.output)! })
        
        // defaults to "old * old", gets overwritten if not
        var operation = Operation.square
        let opFn = specLines[2].firstMatch(of: /[\*\+]+/)!.output
        if let opNumber = specLines[2].firstMatch(of: /\d+/) {
            operation = Operation(opFn: opFn, opNumber: Int(opNumber.output)!)
        }
        
        let testDivisor = Int(specLines[3].firstMatch(of: /\d+/)!.output)!
        
        let ifTrue = Int(specLines[4].firstMatch(of: /\d+/)!.output)!
        let ifFalse = Int(specLines[5].firstMatch(of: /\d+/)!.output)!
        
        monkeys.append(
            Monkey(
                id: id,
                itemQueue: startingItems,
                nextMonkeyIds: [true: ifTrue, false: ifFalse],
                operation: operation,
                testDivisor: testDivisor
            )
        )
    }
    
    return monkeys
}

enum Operation {
    case add(Int)
    case multiply(Int)
    case square
    
    init(opFn: some StringProtocol, opNumber: Int) {
        switch opFn {
        case "+":
            self = .add(opNumber)
        default:
            self = .multiply(opNumber)
        }
    }
}

struct ItemTransfer {
    let monkeyId: Int
    let itemValue: Int
}

class Monkey {
    let id: Int
    private var itemQueue: [Int]
    let nextMonkeyIds: [Bool: Int]
    let operation: Operation
    let testDivisor: Int
    var inspectionCount = 0
    
    init(id: Int, itemQueue: [Int], nextMonkeyIds: [Bool : Int], operation: Operation, testDivisor: Int) {
        self.id = id
        self.itemQueue = itemQueue
        self.nextMonkeyIds = nextMonkeyIds
        self.operation = operation
        self.testDivisor = testDivisor
    }
    
    func addItem(item: Int) {
        self.itemQueue.append(item)
    }
    
    func inspectInventory(reduceWorry: Bool = true, worryModulus: Int) -> [ItemTransfer] {
        var transfers: [ItemTransfer] = []
        while itemQueue.count > 0 {
            inspectionCount += 1
            let item = itemQueue.removeFirst()
            
            var worryLevel: Int = 0
            switch self.operation {
            case .square:
                worryLevel = item * item
            case .multiply(let num):
                worryLevel = item * num
            case .add(let num):
                worryLevel = item + num
            }
            
            worryLevel %= worryModulus
            
            if reduceWorry {
                worryLevel /= 3
            }
            
            
            transfers.append(ItemTransfer(
                monkeyId: nextMonkeyIds[(worryLevel % self.testDivisor) == 0]!,
                itemValue: worryLevel)
            )
        }
        
        return transfers
    }
}
