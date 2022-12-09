import Algorithms

struct Rule {
    var winsAgainst: HandSign
    var value: Int
}

enum HandSign: CaseIterable {
    case rock
    case paper
    case scissors
    
    func getRule() -> Rule {
        switch self {
        case .rock:
            return Rule(winsAgainst: .scissors, value: 1)
        case .paper:
            return Rule(winsAgainst: .rock, value: 2)
        case .scissors:
            return Rule(winsAgainst: .paper, value: 3)
        }
    }
}

enum GameOutcome: Int {
    case win = 6
    case draw = 3
    case lose = 0
}

func letterCodeToHandsign(letter: String) -> HandSign? {
    if ["A", "X"].contains(letter) {
        return .rock
    }
    
    if ["B", "Y"].contains(letter) {
        return .paper
    }
    
    if ["C", "Z"].contains(letter) {
        return .scissors
    }
    
    return nil
}

func letterCodeToOutcome(letter: String) -> GameOutcome? {
    switch letter {
    case "X":
        return .lose
    case "Y":
        return .draw
    case "Z":
        return .win
    default:
        return nil
    }
}

public func partOne() {
    let games = input.split(separator: "\n")
    
    var score = 0
    for game in games {
        let plays = game.split(separator: " ")
        let challenge = letterCodeToHandsign(letter: String(plays[0]))!
        let response = letterCodeToHandsign(letter: String(plays[1]))!
        let rule = response.getRule()
        
        score += rule.value
        if rule.winsAgainst == challenge {
            score = score + GameOutcome.win.rawValue
        } else if response == challenge {
            score = score + GameOutcome.draw.rawValue
        }
    }
    
    print("Day 02, Part 1 :: \(score)")
}

public func partTwo() {
    let games = input.split(separator: "\n")
    
    var score = 0
    for game in games {
        let playAndOutcome = game.split(separator: " ")
        let challenge = letterCodeToHandsign(letter: String(playAndOutcome[0]))!
        let outcome = letterCodeToOutcome(letter: String(playAndOutcome[1]))!
        let challengeRule = challenge.getRule()
        
        score += outcome.rawValue
        if outcome == .draw {
            score += challengeRule.value
        } else if outcome == .lose {
            let losingHandSign = challenge.getRule().winsAgainst
            score += losingHandSign.getRule().value
        } else {
            let losingHandSign = challengeRule.winsAgainst
            score += HandSign.allCases.first(where: { ![losingHandSign, challenge].contains($0) })!.getRule().value
        }
    }
    
    print("Day 02, Part 2 :: \(score)")
}
