require 'sinatra'
require 'sinatra/reloader'
require 'yaml'

@@secret_word = ""
@@misses = []
@@correct_guesses = []
@@miss_count = 5
@@message = ""
@@level = 0
@@victory = false
@@message_2 = ""

def reset(level)
  level = level.to_i
  @@secret_word = YAML.load_file('../hang_man/library.yml')[level].sample
  # params.delete :guess
  @@misses = []
  @@correct_guesses = []
  @@message = ""
  @@miss_count = 5
  @@victory = false
  @@message_2 = ""
end

def make_guess(guess)
  guess = guess.downcase
  return @@message = "Careful, your guess must be a single letter" if !('a'..'z').include?(guess)
  if !@@secret_word.nil? && !guess.nil?
    if @@secret_word.include?(guess)
      # add that character to misses
      @@correct_guesses << guess if !@@correct_guesses.include?(guess)
      @@message = "Good one!"
    else
      #add to misses
      @@misses << guess if !@@misses.include?(guess)
      @@miss_count -= 1
      @@message = "nope, no \"#{guess}\" !"
    end
  end
end

def restart()
  params.delete :guess
  @@message = ""
  @@secret_word = ""
  @@correct_guesses = []
  @@victory = false
end

def victory()
  @@victory = true
  @@message = "You guessed '#{@@secret_word}' and saved our man!"
  @@message_2 = "\<br\>Would you like to play again?"
end

get '/' do
  reset(params[:level]) if params[:level]
  restart()if params[:restart] #show start menue
  make_guess(params[:guess]) if params[:guess] #process guess
  victory() if @@secret_word.split("") - @@correct_guesses == [] && @@secret_word.length > 1
  # loss() if 
  erb :index, :locals => { :secret_word => @@secret_word, :misses => @@misses, :miss_count => @@miss_count, :correct_guesses => @@correct_guesses, :message => @@message, :level => @@level, :victory => @@victory, :message_2 => @@message_2 }
  # throw params.inspect
end