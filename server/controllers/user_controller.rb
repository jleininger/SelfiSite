require 'mongo'
require './server/controllers/application_controller'

class UserController < ApplicationController
    
    @@client = Mongo::Client.new("mongodb://jleininger:selfisite@ds047692.mongolab.com:47692/selfisite_db")
    @@db = @@client[':users']
    
    def initialize
        
    end
    
    public 
    
    def self.createUser(name, username, email, password)
       @@db.insert_one({name: name, username: username, email: email, password: password, images: []})
    end
    
    def self.getUser(username)
        return @@db.find("username" => username).to_a[0]
    end
    
    def self.checkUserPassword(username, password)
        user = UserController.getUser(username)
        return user["password"] == password
    end
    
    def self.addUserImage(username, name, path)
        user = UserController.getUser(username)
        images = user["images"]
        images.push({
            name: name,
            path: path
        })
        @@db.find("username" => username).update_one(user)
    end
end