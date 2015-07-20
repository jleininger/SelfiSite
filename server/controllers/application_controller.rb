require 'sinatra/base'
require 'mongo'

class ApplicationController < Sinatra::Base
    
    #Sinatra Setup
    set :views, File.dirname(__FILE__) + "/public/views"
    set :bind, '0.0.0.0'
    set :port, 3000
    
    #MongoDB Set 
    @@client = Mongo::Client.new("mongodb://jleininger:selfisite@ds047692.mongolab.com:47692/selfisite_db")
    #result = client[':users'].insert_one({name: 'dude'})
    #puts result.n

end