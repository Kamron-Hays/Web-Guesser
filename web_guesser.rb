require 'sinatra'
require 'sinatra/reloader'

number = rand(101)

get '/' do
  "The SECRET number is #{number}"
end
