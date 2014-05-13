def score(cards)
	total = cards.map{ |e| e[1] }
	
	points = 0

	total.each do |card|
		if card == "A"
			points = points + 11
		elsif card.to_i == 0
			points = points + 10
		else
			points = points + card.to_i	
		end
	end

	total.select{|e| e == "A"}.count.times do
		if points > 21
			points = points - 10
		end
	end

	points
end


puts 'Welcome to Backjack! What\'s your name?'
$name = gets.chomp

def play
	puts "Thanks for playing #{$name}."

	suit = ['H', 'D', 'C', 'S']
	cards = ['2', '3', '4', '5', '6', '7', '8', '9', 'J', 'Q', 'K', 'A']

	deck = suit.product(cards)
	deck.shuffle!

	player_cards = []
	dealer_cards = []

	player_cards << deck.pop
	dealer_cards << deck.pop
	player_cards << deck.pop
	dealer_cards << deck.pop

	player_total = score(player_cards)
	dealer_total = score(dealer_cards)

	puts "#{$name} has " + player_cards.to_s + " and #{player_total} points."
	puts "Dealer has " + dealer_cards.to_s + " and #{dealer_total} points."

	if dealer_total == 21
		puts "Dealer has #{dealer_total}. Blackjack! Dealer wins!"
	else
		while player_total < 21
			puts "Would you like to 'hit' or 'stay'?"
			hit_or_stay = gets.chomp
			if hit_or_stay =='hit'
				player_cards << deck.pop
				player_total = score(player_cards)
				puts "#{$name} has " + player_cards.to_s + " and #{player_total} points."
			elsif hit_or_stay == 'stay'
				break
			else
				puts "Please enter 'hit' or 'stay'"
				next 
			end
		end
		
		if player_total == 21
			puts "Blackjack! #{$name} wins!"
		elsif player_total > 21
			puts "#{$name} has #{player_total}. #{$name} busts; dealer wins!"
		else
			while dealer_total < 17
				dealer_cards << deck.pop
				dealer_total = score(dealer_cards)
				puts "Dealer goes..."
				puts "Dealer has " + dealer_cards.to_s + " and #{dealer_total} points."	
			end

			if dealer_total < player_total
				puts "#{$name} has #{player_total}, dealer has #{dealer_total}. #{$name} wins!"
			elsif dealer_total > 21
				puts "Dealer busts! #{$name} wins!"
			elsif dealer_total == player_total
				puts "#{$name} and dealer are tied. Dealer wins!"
			elsif dealer_total > player_total
				puts "#{$name} has #{player_total}, dealer has #{dealer_total}. Dealer wins!"
			end
		end
	end

	def play_again
		puts "Would you like to play again (yes or no)?"
		answer = gets.chomp
		if answer == 'yes'
			play
		elsif answer == 'no'
			puts 'Thanks for playing. See you next time.'
		else
			puts 'Please answer yes or no.'
			play_again
		end
	end

	play_again
end

play