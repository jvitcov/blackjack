class Card
	attr_accessor :suit, :value

	def initialize (v, s)
		@value = v
		@suit = s
	end

	def to_s
		"#{value} of #{suit}"
	end

end

class Deck
	attr_accessor :cards

	def initialize
		@cards = []
		['Hearts', 'Diamonds', 'Spades', 'Clubs'].each do |suit|
			['2', '3', '4', '5', '6', '7', '8', '9', 'Jack', 'Queen', 'King', 'Ace'].each do |face_value|
				@cards << Card.new(face_value, suit)
			end
		end
		shuffle_cards
	end

	def shuffle_cards
		cards.shuffle!
	end

	def deal
		cards.pop
	end
end

module Hand
	def show_hand
		puts " "
		puts "-----#{name} has:"
		cards.each do |card|
			puts "=> #{card}"
		end
		puts "For a score of #{score}"
		puts " "
	end

	def score
		total = cards.map{ |card| card.value }
	
		points = 0

		total.each do |card|
			if card == "Ace"
				points = points + 11
			elsif card.to_i == 0
				points = points + 10
			else
				points = points + card.to_i	
			end
		end

		total.select{|e| e == "Ace"}.count.times do
			if points > 21
				points = points - 10
			end
		end

		points
	end

	def hit(new_card)
		cards << new_card
	end

	def is_busted
		score > Blackjack::BLACKJACK
	end
end

class Player
	include Hand
	
	attr_accessor :name, :cards

	def initialize(n)
		@name = n
		@cards = []
	end

end

class Dealer
	include Hand

	attr_accessor :name, :cards

	def initialize
		@name = "Dealer"
		@cards = []
	end

	def show_flop
		puts " "
		puts "-----Dealer has:"
		puts "First card is hidden."
		puts "=> #{cards[1]}"
		puts " "
	end
end


 
class Blackjack
	#game engine

	attr_accessor :player, :dealer, :deck

	BLACKJACK = 21
	DEALER_STAYS = 17

	def initialize
		@player = Player.new('name')
		@dealer = Dealer.new
		@deck = Deck.new
	end

	def player_name
		if player.name == 'name'
			puts "Welcome to Blackjack!"
			puts "What's your name?"
			player.name = gets.chomp.capitalize
			puts " "
			puts "Thanks for playing, #{player.name}. Here we go..."
		else
			puts "Thanks for playing again #{player.name}."
		end
	end

	def deal_cards
		player.hit(deck.deal)
		dealer.hit(deck.deal)
		player.hit(deck.deal)
		dealer.hit(deck.deal)
	end

	def show_hands
		dealer.show_flop
		player.show_hand
	end

	def blackjack_bust(player_dealer)
		if player_dealer.score == BLACKJACK
				if player_dealer.is_a?(Dealer)
					puts "Dealer hit blackjack. #{player.name} loses."
				else
					puts "#{player.name}, you hit blackjack! You win!"
				end
				play_again
		elsif player_dealer.is_busted
				if player_dealer.is_a?(Dealer)
					puts "Dealer busted. #{player.name} wins!"
				else
					puts "#{player.name}, you busted. Dealer wins."
				end
				play_again
		end
	end

	def player_turn

		blackjack_bust(player)

		while !player.is_busted

			puts "Would you like to 'hit' or 'stay'?"
			response = gets.chomp
			if response == 'hit'
				player.hit(deck.deal)
				player.show_hand
				blackjack_bust(player)
			elsif response == 'stay'
				puts "#{player.name} stays."
				break
			elsif response != 'hit' || response != 'stay'
				puts "Please type 'hit' or 'stay'"
			end
		end

		blackjack_bust(player)
	end

	def dealer_turn
		player.show_hand
		dealer.show_hand
		puts "Dealer's Turn:"
		puts "Dealer has: #{dealer.score}"
		puts " "
		blackjack_bust(dealer)
		while dealer.score < DEALER_STAYS
			dealer.hit(deck.deal)
			puts "Dealer hits..."
			dealer.show_hand
		end
		blackjack_bust(dealer)
	end

	def who_won
		if player.score < dealer.score
			puts "Dealer stayed with: #{dealer.score}."
			puts "#{player.name} stayed with: #{player.score}."
			puts "Dealer wins!"
		elsif player.score > dealer.score
			puts "Dealer stayed with: #{dealer.score}."
			puts "#{player.name} stayed with: #{player.score}."
			puts "#{player.name} wins!"
		else #tie
			puts "Dealer stayed with: #{dealer.score}."
			puts "#{player.name} stayed with: #{player.score}."
			puts "It's a tie. Dealer wins!"
		end
	end

	def play_again
		puts " "
		puts "Would you like to play again?"
		reply = gets.chomp
		if reply == 'yes'
			deck = Deck.new
			player.cards = []
			dealer.cards = []
			play
		elsif reply == 'no'
			exit
		else
			puts "Please enter 'yes' or 'no'."
			play_again
		end		
	end

	def play
		player_name
		deal_cards
		show_hands
		player_turn
		dealer_turn
		who_won
		play_again
	end
end

Blackjack.new.play
