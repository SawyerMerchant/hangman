require 'sinatra'
require 'sinatra/reloader'
require 'yaml'

@@secret_word = ""
@@misses = []
@@correct_guesses = []
@@miss_count = 5
@@message = ""
@@level = 0
def reset(level)
  level = level.to_i
  @@secret_word = YAML.load_file('../hang_man/library.yml')[level].sample
  # params.delete :guess
  @@misses = []
  @@correct_guesses = []
  @@message = ""
  @@miss_count = 5
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
      @@message = "nope, no #{guess}!"
    end
  end
end

get '/' do
  reset(params[:level]) if params[:level]
  guess = params[:guess]
  # @@level = params[:level].to_i
  # if ('a'..'z').include?(guess.downcase)
  make_guess(guess) if params[:guess]
  # else
  #   message = "Careful, you can only guess a single letter at a time"
  # end
  erb :index, :locals => { :secret_word => @@secret_word, :misses => @@misses, :miss_count => @@miss_count, :correct_guesses => @@correct_guesses, :message => @@message, :level => @@level }
  # throw params.inspect
end