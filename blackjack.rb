# blackjack.rb

require 'pry'

# create a deck of cards

def deck_create

  deck_suits = ["Hearts", "Spades", "Diamonds", "Clubs"]

  deck_values = { "2" => 2, "3" => 3, "4" => 4, "5" => 5, "6" => 6, 
                "7" => 7, "8" => 8, "9" => 9, "10" => 10, "J" => 10, 
                "Q" => 10, "K" => 10, "A" => 11 }
               
  single_deck = []

  deck_values.each do | key, val |
    deck_suits.each do | suit |
      single_deck << [(key +"-" + suit), val]
    end
  end
  return single_deck
end

# method to shuffle a deck of cards

def shuffle(deck)
  puts "Shuffling..."
  sleep(1)
  3.times {deck.shuffle!}
  puts "Deck shuffled!"
end

# method for intial dealing of cards
 
def initial_deal(deck, player, dealer)
  puts "\nDealing.."
  sleep(1)
  2.times do
    player << deck.shift
    dealer << deck.shift
  end
  puts "Cards Dealt!"
end

# method for displaying full hand

def hand_display(person="Player",cards)
  print "#{person} hand - "
  cards.each do |sub_array|
    print sub_array.first + " / "
  end
  puts "or #{hand_value(cards)}"
end

# method for calculating value of cards

def hand_value(cards)
  value = 0
  cards.each do |sub_array|
      if sub_array.last == 11 && value > 10
        value = value + 1
      else
        value = value + sub_array.last
      end
  end
  return value
end


# establish inital game conditions

player_name = nil 
player_balance = 1000
game_deck = deck_create
player_cards = []
dealer_cards = []
player_bet = 0


# invite player to play blackjack

while player_name == nil || player_name == "" do
  
  puts "Would you like to play blackjack? ( y / n )"
  player_answer = gets.chomp

  if player_answer == 'y'
    puts "What is your name?"
    player_name = gets.chomp
    
  elsif player_answer == 'n'
    puts "Sorry, maybe next time."
    exit
  else
    puts "Please answer 'y' or 'n'"
  end
end

# greet player

puts "\nWelcome, #{player_name}!"
puts "\n#{player_name}, we will start you off with #{player_balance} chips."
sleep(1)

# shuffle the deck

puts "\n"
shuffle(game_deck)
puts "\n"

# start the game loop

while player_balance > 0 do
  
# make sure player makes a bet
  
  while player_bet == 0 do
    puts "How much would you like to bet?"
    bet = gets.chomp
  
    if bet.to_i.is_a?(Integer) && bet.to_i > 00 && bet.to_i <= player_balance
      puts "\nOK, your bet is #{bet.to_i}."
      player_bet = bet.to_i
    else
      puts "Your bet must be a whole number between 1 and #{player_balance}!"
    end
  end
  
# deal out cards and set hand values
    
  initial_deal(game_deck, player_cards, dealer_cards)

  player_hand_value = hand_value(player_cards)
  dealer_hand_value = hand_value(dealer_cards)

  hand_display(player_cards)
  puts "\nThe dealer is showing #{dealer_cards.last.first}"

# sub-loop for player hitting & staying

  while player_hand_value <= 21 && dealer_hand_value <= 21 do
    
# if player has blackjack - move to end game

    if player_hand_value == 21
     break
    end

# if no blackjack, check to see if the player wants to hit or stay
      
    while player_hand_value < 21 && dealer_hand_value <= 21 do

      puts "\nWhat would you like to do? (put 'h' for hit or 's' for stay)"
      player_action = gets.chomp
  
      if player_action == 'h'
        puts "\nYou have chosen to hit"
        player_cards << game_deck.shift
        player_hand_value = hand_value(player_cards)
        hand_display(player_cards)
        puts "\nThe dealer is showing #{dealer_cards.last.first}"
      elsif player_action == 's'
        break
      else
        puts "you must choose either 'h' or 's'"
      end
    end
  
    if player_hand_value <= 21
      puts "\nYou have chosen to stay on #{player_hand_value}"
    else
      break
    end

    puts "\nThe dealer turns over the #{dealer_cards.first.first}.  He has #{dealer_hand_value}"
      
    while dealer_hand_value <= 21
      
      if dealer_hand_value < 17
        sleep(1)
        puts "The dealer must hit."
        dealer_cards << game_deck.shift
        dealer_hand_value = hand_value(dealer_cards)
        puts hand_display("Dealer",dealer_cards)
        sleep(1)
      elsif dealer_hand_value >= 17 && dealer_hand_value <= 21
        puts "The dealer is staying on #{dealer_hand_value}"
        break
      end
    end
  
    if dealer_hand_value <= 21
      break
    end
  end
  
# payout scenarios

    if player_hand_value == 21 && player_cards.length == 2
      puts "\nBLACKJACK! You win 2x your bet!"
      sleep(0)
      player_winnings = player_bet * 2
      player_balance = player_balance + player_winnings
      puts "You've won #{player_winnings} - your new balance is: #{player_balance}"
    elsif player_hand_value > 21
      puts "\nYou've busted!  Dealer wins."
      player_balance = player_balance - player_bet
      puts "Your new balance is #{player_balance}."
    elsif dealer_hand_value > 21
      puts "\nDealer has busted.  You win!"
      player_balance = player_balance + player_bet
      puts "Your new balance is #{player_balance}."
    elsif dealer_hand_value > player_hand_value
      puts "\nDealer wins!"
      player_balance = player_balance - player_bet
      puts "Your new balance is #{player_balance}."
    elsif player_hand_value > dealer_hand_value
      puts "\nPlayer wins!"
      player_balance = player_balance + player_bet
      puts "Your new balance is #{player_balance}."
    else
      puts "\nIt's a push!"    
    end


  if player_balance > 0
    puts "\nWould you like to keep playing? (y / n)"
    player_answer = gets.chomp
 
      if player_answer == 'n'
        break
      else
        player_bet = 0
        player_cards = []
        dealer_cards = []
        if game_deck.length < 20
          game_deck = deck_create
          shuffle(game_deck)
        end
      end
  else
    puts "You've lost all your chips!  Game over."
    break
  end

  puts "cards remaining - #{game_deck.length}"

end
