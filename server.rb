require 'sinatra'
require './server/controllers/user_controller'

set :views, File.dirname(__FILE__) + "/public/views"
set :bind, '0.0.0.0'
set :port, 3000
enable :sessions
set :session_secret, 'Kim Jong Un riding a unicorn'

get '/' do
  @title = "Welcome to SelfiSite"
  @user = session['loggedIn']
  erb :home
end

post '/signup' do
    name = params[:name]
    email = params[:email]
    username = params[:username]
    password = params[:password]
    confirmPassword = params[:confirmPassword]
    
    if password == confirmPassword
        if !UserController.checkExistingUsername(username)
            UserController.createUser(name, username, email, password)
            setLoggedIn(username)
        else
            puts "User already exists!"
        end
    else
        puts "Passwords don't match!"
    end
    redirect '/'
end

post '/signin' do
   username = params[:username]
   password = params[:password]
   if UserController.checkUserPassword(username, password)
       setLoggedIn(username)
       redirect '/'
   end
end

post '/edit/image' do
    username = params[:username]
    if username = session['loggedIn']
        image_path = params['image_path']
        new_name = params['new_name']
        new_desc = params['new_desc']
        UserController.editUserImage(username, image_path, new_name, new_desc)
        redirect '/'
    end
end

post '/delete/:username/:image' do
    UserController.deleteUserImage(params[:username], "#{params[:username]}/#{params[:image]}")
    redirect '/'
end 

post '/upload' do
    username = session['loggedIn']
    name = params[:filename]
    desc = params[:fileDesc]
    filename = "#{username}/#{params[:file_upload][:filename]}"
    
    Dir.mkdir("public/uploads/#{username}") unless File.exists?("public/uploads/#{username}")
    
    if(!File.file?("public/uploads/#{filename}"))
        File.open("public/uploads/" + filename, "wb") do |f|
            f.write(params['file_upload'][:tempfile].read)
        end
  
        UserController.addUserImage(session['loggedIn'], name, desc, filename)
    else
        puts "File already exists! Change file name."
    end
  
    redirect('/')
end

get '/logout' do
    session.clear
    redirect '/' 
end

get '/:username' do
   @user = session['loggedIn']    
   user = UserController.getUser(params['username'])
   @username = user['username']
   @name = user['name']
   @email = user['email']
   @images = user['images']
   erb :profile
end

def checkLoggedIn
    return (session['loggedIn'] != nil) ? true : false
end

def setLoggedIn(username)
    session['loggedIn'] = username
end