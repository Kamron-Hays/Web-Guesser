# This is called the server file.

require 'sinatra'
require 'sinatra/reloader' if development?

set :max_guesses, 5
set :intro, "I'm thinking of a number between 1 and 100. Try to guess it in #{settings.max_guesses} or fewer tries."
# Multiple settings can also be set by passing a hash to set:
# set :number => rand(1..100), :show_number => false, :message => nil

enable :sessions

# The HTML spec says GET requests should not change the state of the application.
get '/' do
  # Render the ERB template named 'index'
  erb :index
end

# Use POST requests to change application state.
post '/' do
  if session[:init].nil?
    session[:number] = rand(1..100)
    session[:guesses_left] = settings.max_guesses
    session[:show_number] = false
    session[:message] = nil
    session[:play_again] = nil
    session[:init] = true
  end

  if params["guess"] != nil
    # The 'params' method returns a hash with the ERB form input (the guess).
    if params["guess"].downcase == "cheat"
      session[:show_number] = !session[:show_number] # toggle cheat mode
    else
      guess = params["guess"].to_i
      session[:message] = "You guessed #{guess}. "
      check_guess(guess)
    end
  end

  # Initiate a GET request to display the updated state.
  redirect "/"
end

def check_guess(guess)
  correct_guess = false
  session[:guesses_left] -= 1

  if guess > session[:number]
    session[:message] += (guess - session[:number] > 5) ? "<span id='way_off'>Way too high!</span>" : "<span id='off'>Too high!</span>"
  elsif guess < session[:number]
    session[:message] += (session[:number] - guess > 5) ? "<span id='way_off'>Way too low!</span>" : "<span id='off'>Too low!</span>"
  else
    session[:message] += "<span id='correct'>You got it right!</span>"
    correct_guess = true
  end

  if !correct_guess
    if session[:guesses_left] == 0
      session[:message] += " You've run out of guesses."
    else
      guesses = session[:guesses_left] == 1 ? "guess" : "guesses"
      session[:message] += " You have #{session[:guesses_left]} #{guesses} left."
    end
  end

  if correct_guess || session[:guesses_left] == 0
    session[:show_number] = true
    session[:play_again] = "Let's play again with a new number!"
    session[:init] = nil
  end
end
