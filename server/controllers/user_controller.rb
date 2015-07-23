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
    
    def self.checkExistingUsername(username)
        existingUser = UserController.getUser(username)
        return (existingUser != nil)
    end
    
    def self.addUserImage(username, name, desc, path)
        user = UserController.getUser(username)
        images = user["images"]
        images.push({
            name: name,
            desc: desc,
            path: path
        })
        @@db.find("username" => username).update_one(user)
    end
    
    def self.editUserImage(username, image_path, new_name, new_desc)
        user = UserController.getUser(username)
        images = user["images"] 
        editable_image = images.select{ |image| image["path"] == image_path }
        editable_image[0]["name"] = new_name
        editable_image[0]["desc"] = new_desc
        puts editable_image
        @@db.find("username" => username).update_one(user)
    end
    
    def self.deleteUserImage(username, image_path)
        user = UserController.getUser(username)
        images = user["images"]
        delete_image = images.select{ |image| image['path'] == image_path }
        delete_image_path = delete_image[0]['path'].to_s
        FileUtils.rm("public/uploads/#{delete_image_path}")
        images.delete_at(images.find_index { |image| image["path"] == image_path })
        @@db.find("username" => username).update_one(user)
    end
end