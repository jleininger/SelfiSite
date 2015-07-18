require 'sinatra'

set :views, File.dirname(__FILE__) + "/public/views"

get '/' do
  @title = "Welcome to SelfiSite"
  erb :home
end

