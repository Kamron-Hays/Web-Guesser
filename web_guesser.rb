# This is called the server file.

require 'sinatra'
require 'sinatra/reloader'

# Generate a number between 0 and 99, then add 1 to it
# to get a number between 1 and 100.
set :number, rand(1..100)
set :show_number, false
set :message, nil
# Multiple settings can also be set by passing a hash to set:
# set :number => rand(1..100), :show_number => false, :message => nil

get '/' do
  # The 'params' method returns a hash with the ERB form input (the guess).
  if params["guess"] != nil
    guess = params["guess"].to_i
    settings.message = "You guessed #{guess}. "
    check_guess(guess)
  end

  # Render the ERB template named 'index' and create a local variable for the
  # template named 'number', which has the same value as the 'number' variable
  # from this server code.
  #erb :index, :locals => {:number => number, :show_number => show_number, :message => message}
  # Instead of passing local variables, just use settings, which are accessible inside the view.
  erb :index
end

def check_guess(guess)
  if guess > settings.number
      settings.message += (guess - settings.number > 5) ? "Way too high!" : "Too high!"
    elsif guess < settings.number
      settings.message += (settings.number - guess > 5) ? "Way too low!" : "Too low!"
    else
      settings.message += "You got it right!"
      settings.show_number = true
    end
end
