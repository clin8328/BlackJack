class Card {
  var face:String
  var value:Int
  var suit:String
  init(_ face:String, _ value:Int, _ suit:String){
    self.face = face
    self.value = value
    self.suit = suit
  }
}

class Deck{
  var cards = [Card]()
  var suits = ["Ace","Heart","Diamond","Club"]
  init(){
    var startValue = 127137 
    for s in 0 ... 3{
      for i in 0 ... 13{
        if i != 11 {
          let face = String(Unicode.Scalar(startValue + i)!)
          let value = (i<10) ? i+1 : 10
          cards.append(Card(face,value,suits[s])) 
        }
      }
      startValue += 16
    }
  }
  func display(){
    var suit = ""
    for card in cards{
      if card.suit != suit {
        suit = card.suit
        print()
      }
      print(card.face, terminator: " ")
    }
    print()
  }
  func draw() -> Card{
    let r = Int.random(in: 0 ... cards.count - 1)   
    return cards.remove(at: r)
  }
}
var deck =  Deck()

class Player{
  var hand:String = ""
  var value:Int = 0
  init(){
    self.hit()
    self.hit()
  }
  func hit(){
    let card = deck.draw()
    self.value += card.value
    self.hand += card.face 
  }
}
var emojiFaces = ["\u{1F916}","\u{1F47A}","\u{1F608}","\u{1F9E0}","\u{1F921}","\u{1F47D}","\u{1F913}","\u{1F60E}","\u{1F974}","\u{1F4A9}","\u{1F9D0}","\u{1F5FF}"]
class Opponent:Player{
  var emoji:String = ""
  var aggressiveness:Int = 0
  var stay = false
  override init(){
    super.init()
    let r = Int.random(in: 0 ... emojiFaces.count - 1)
    self.emoji = emojiFaces[r]
    self.aggressiveness = Int.random(in: 1 ... 3)
  }
  override func hit(){
    let r = Int.random(in: 1 ... 3)
    if !stay && (self.value <= 10 || (self.aggressiveness > r && self.value < 16)) {
      super.hit()
    }else{
      stay = true
    }
  }
  func display(_ all:Bool) -> String{
    let range = self.hand.index(after: self.hand.startIndex)..<self.hand.endIndex
    return self.emoji + "  " + ((!all) ? "\u{1F0A0}" + self.hand[range] : self.hand)
  }
}

var user = Player()
var opponents = [Opponent(),Opponent(),Opponent()]
func displayRoom(_ all:Bool = false){
  let o1 = opponents[0].display(all), o2 = opponents[1].display(all), o3 = opponents[2].display(all)
  print("\u{001B}[2J")
  print("\(String(repeating:"\u{27B0}",count:8))   Black Jack \(String(repeating:"\u{27B0}",count:8))")
  print("\u{27B0}                            \u{27B0}")
  print("\u{27B0}           \(o1)\(String(repeating: " ", count: 17 - o1.count) )\u{27B0}")
  print("\u{27B0}                            \u{27B0}")
  print("\u{27B0}  \(o2)\(String(repeating: " ", count: 17 - o2.count) )\(o3)\(String(repeating: " ", count: 9 - o3.count) )\u{27B0}")
  print("\u{27B0}                            \u{27B0}")
  print("\u{27B0}           \u{1F644}  \(user.hand)\(String(repeating: " ", count: 14 - user.hand.count) )\u{27B0}")
  print("\u{27B0}                            \u{27B0}")
  print("\(String(repeating: "\u{27B0}", count: 30))\n")
  print("Dealer \u{1F911}  " , terminator:"")
  print((!all) ? "(Hit or Stay): " : ": " , terminator:"")
}

var input = "", opponents_stay = false
while input != "stay" && user.value < 21 && !opponents_stay {
  displayRoom()
  input = readLine()!
  if input == "hit"{
    user.hit()
  }
  opponents_stay = true
  for o in opponents{
    o.hit()
    if !o.stay{
      opponents_stay = false
    }
  }
}
displayRoom(true)
var winner = "\u{1F644}"
var hand  = user.hand
var value = (user.value <= 21) ? user.value : 0
for o in opponents{
  if o.value >= value && o.value <= 21{
    winner = o.emoji
    hand = o.hand
    value = o.value
  }
}
print("Winner \(winner)   \(hand)")
let wait = readLine()!



