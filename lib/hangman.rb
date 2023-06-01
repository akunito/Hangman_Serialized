# project Ruby Hangman
# https://www.theodinproject.com/lessons/ruby-hangman

require "open-uri"
require "json"

module GameLibrary
  def get_random_word_5_12
    # https://raw.githubusercontent.com/first20hours/google-10000-english/master/google-10000-english-no-swears.txt
    # Load dictionary and randomly select a word between 5 and 12 characters long for the secret word.
    remote_base_url = "https://raw.githubusercontent.com/first20hours/google-10000-english/master/"
    remote_page_name = "google-10000-english-no-swears.txt"
    remote_full_url = remote_base_url + "/" + remote_page_name

    remote_data = URI.open(remote_full_url).read
    remote_data = remote_data.split
    remote_data.select! { |word| word.length >= 5 && word.length <= 12}
    remote_data[rand(remote_data.length)]
  end

  def user_input
    puts "Select an English character A-Z: "
    gets.downcase.to_s[0]
  end

  def lives(number)
    heart = "❤️ "
    heart * (number-1)
  end

  def search_char_into_word(char, word, found_word)
    word = word.split('')
    word.each_with_index { |e, i| found_word[i] = e if e == char }
    found_word
  end

end

module MenuLibrary
  def print_main_menu
    puts
    puts "0 - Exit"
    puts "1 - Play Hangman"
    puts "2 - Save game"
    puts "3 - Load game"
    puts
  end
end

class Game
  include GameLibrary

  def initialize
    @round = 1
    @guesses = 16
    @secret_word = get_random_word_5_12
    @found_word = Array.new(@secret_word.length, "_")
  end

  def play
    while @round
      puts
      @round += 1
      # show how many guesses left before dying painfully
      puts lives(@guesses-@round)
      # get user input
      selection = user_input
      puts selection
      # show discovered characters
      @found_word = search_char_into_word(selection, @secret_word, @found_word)
      p @found_word.join
      # check win or lose
      if @secret_word == @found_word.join
        puts
        puts "You WON !! The secret word was --> #{@secret_word} <--"
        puts
        break
      elsif @round >= @guesses
        puts
        puts "You LOST so you DIE slow and painfully !!"
        puts "The secret word was --> #{@secret_word} <-"
        puts
        break
      end
    end
  end

end

include MenuLibrary
playing = true

hangman = Game.new
while playing

  print_main_menu
  selection = gets.to_i
  case selection
  when 0
    playing = false
  when 1
    hangman.play
  when 2
    # save game
  when 3
    # load game
  else
    break
  end

end


# Now implement the functionality where, at the start of any turn, instead of making a guess the player should also
# have the option to save the game. Remember what you learned about serializing objects… you can serialize your game
# class too!


# When the program first loads, add in an option that allows you to open one of your saved games, which should jump
# you exactly back to where you were when you saved. Play on!

