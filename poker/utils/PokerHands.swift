//----------------------//----------------------
import UIKit
//----------------------//----------------------
class PokerHands {
    //==============================================
    func royalFlush(hand: [(card: Int, suit: String)]) -> Bool {
        //--
        var cards = [Int]()
        var suits = [String]()
        //--
        for c in hand {
            cards.append(c.card)
            suits.append(c.suit)
        }
        //--
        cards.sort{$0 < $1}
        suits.sort{$0 < $1}
        //--
        if cards != [1, 10, 11, 12, 13] {
            return false
        }
        //--
        if !flush(hand: hand) {
            return false
        }
        //--
        return true
    }
    //==============================================
    func straightFlush(hand: [(card: Int, suit: String)]) -> Bool {
        //--
        var cards = [Int]()
        var suits = [String]()
        //--
        for c in hand {
            cards.append(c.card)
            suits.append(c.suit)
        }
        //--
        cards.sort{$0 < $1}
        suits.sort{$0 < $1}
        //--
        if !straight(hand: hand) {
            return false
        }
        //--
        if !flush(hand: hand) {
            return false
        }
        //--
        return true
    }
    //==============================================
    func fourKind(hand: [(card: Int, suit: String)]) -> Bool {
        //--
        let cards = parseTupleReturnArray(hand: hand)
        //--
        if !threeOrFourKind(cards: cards, threeOrFour: 4) {
            return false
        }
        //--
        return true
    }
    //==============================================
    func fullHouse(hand: [(card: Int, suit: String)]) -> Bool {
        //--
        let cards = parseTupleReturnArray(hand: hand)
        //--
        var repeats: [Int: Int] = [:]
        //--
        for item in cards {
            repeats[item] = (repeats[item] ?? 0) + 1
        }
        //--
        if repeats.count != 2 {
            return false
        }
        //--
        return true
    }
    //==============================================
    func flush(hand: [(card: Int, suit: String)]) -> Bool {
        //--
        var suits = [String]()
        //--
        for c in hand {
            suits.append(c.suit)
        }
        //--
        let suit = suits[0]
        //--
        for aSuit in suits {
            if aSuit != suit {
                return false
            }
        }
        //--
        return true
    }
    //==============================================
    func straight(hand: [(card: Int, suit: String)]) -> Bool {
        //--
        var cards = [Int]()
        //--
        for c in hand {
            cards.append(c.card)
        }
        //--
        cards.sort{$0 < $1}
        //--
        if cards == [1,10,11,12,13] {
            return true
        }
        //--
        var number = cards[0]
        //--
        for i in 0..<cards.count {
            if number != cards[i] {
                return false
            } else {
                number = number + 1
            }
        }
        //--
        return true
    }
    //==============================================
    func threeKind(hand: [(card: Int, suit: String)]) -> Bool {
        //--
        let cards = parseTupleReturnArray(hand: hand)
        //--
        if !threeOrFourKind(cards: cards, threeOrFour: 3) {
            return false
        }
        //--
        return true
    }
    //==============================================
    func twoPairs(hand: [(card: Int, suit: String)]) -> Bool {
        //--
        let cards = parseTupleReturnArray(hand: hand)
        //--
        var repeats: [Int: Int] = [:]
        //--
        for item in cards {
            repeats[item] = (repeats[item] ?? 0) + 1
        }
        //--
        if repeats.count != 3 {
            return false
        }
        //--
        for (_, val) in repeats {
            if val == 2 {
                return true
            }
        }
        //--
        return false
    }
    //==============================================
    func onePair(hand: [(card: Int, suit: String)]) -> Bool {
        //--
        let cards = parseTupleReturnArray(hand: hand)
        //--
        var repeats: [Int: Int] = [:]
        //--
        for item in cards {
            repeats[item] = (repeats[item] ?? 0) + 1
        }
        //--
        for (key, val) in repeats {
            if val == 2, key == 1 || key >= 11 {
                return true
            }
        }
        //--
        return false
    }
    //==============================================
    func parseTupleReturnArray(hand: [(card: Int, suit: String)]) -> [Int] {
        //--
        var cards = [Int]()
        //--
        for c in hand {
            cards.append(c.card)
        }
        //--
        return cards.sorted{$0 < $1}
    }
    //==============================================
    func threeOrFourKind(cards: [Int], threeOrFour: Int) -> Bool {
        //--
        var repeats: [Int: Int] = [:]
        //--
        for item in cards {
            repeats[item] = (repeats[item] ?? 0) + 1
        }
        //--
        for (_, val) in repeats {
            if val == threeOrFour {
                return true
            }
        }
        //--
        return false
    }
    //==============================================
}
