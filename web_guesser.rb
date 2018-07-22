# This is called the server file.

require 'sinatra'
require 'sinatra/reloader'

# Generate a number between 0 and 99, then add 1 to it
# to get a number between 1 and 100.
set :init, true
set :number, nil
set :show_number, false
set :message, nil
set :play_again, nil
set :max_guesses, 5
set :intro, "I'm thinking of a number between 1 and 100. Try to guess it in #{settings.max_guesses} or fewer tries."
# Multiple settings can also be set by passing a hash to set:
# set :number => rand(1..100), :show_number => false, :message => nil

@@remaining_guesses = settings.max_guesses

get '/' do
  if settings.init
    settings.number = rand(1..100)
    settings.show_number = false
    @@remaining_guesses = settings.max_guesses
    settings.message = nil
    settings.play_again = nil
    settings.init = false
  end

  if params["guess"] != nil
    # The 'params' method returns a hash with the ERB form input (the guess).
    guess = params["guess"].to_i
    settings.message = "You guessed #{guess}. "
    check_guess(guess)    
  end

  if params["cheat"]
    settings.show_number = true
  end

  # Render the ERB template named 'index' and create a local variable for the
  # template named 'number', which has the same value as the 'number' variable
  # from this server code.
  #erb :index, :locals => {:number => number, :show_number => show_number, :message => message}
  # Instead of passing local variables, just use settings, which are accessible inside the view.
  erb :index
end

def check_guess(guess)
  correct_guess = false
  @@remaining_guesses -= 1

  if guess > settings.number
    settings.message += (guess - settings.number > 5) ? "<span id='way_off'>Way too high!</span>" : "<span id='off'>Too high!</span>"
  elsif guess < settings.number
    settings.message += (settings.number - guess > 5) ? "<span id='way_off'>Way too low!</span>" : "<span id='off'>Too low!</span>"
  else
    settings.message += "<span id='correct'>You got it right!</span>"
    correct_guess = true
  end

  if !correct_guess && @@remaining_guesses == 0
    settings.message += " You've run out of guesses."
  end

  if correct_guess || @@remaining_guesses == 0
    settings.show_number = true
    settings.play_again = "Let's play again with a new number!"
    settings.init = true
  end
end
