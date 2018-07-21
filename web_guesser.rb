# This is called the server file.

require 'sinatra'
require 'sinatra/reloader'

number = rand(101)

get '/' do
  # Render the ERB template named 'index' and create a local variable for the
  # template named 'number', which has the same value as the 'number' variable
  # from this server code.
  erb :index, :locals => {:number => number}
end
