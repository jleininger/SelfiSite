require 'sinatra'
require './server/controllers/user_controller'

set :views, File.dirname(__FILE__) + "/public/views"
set :bind, '0.0.0.0'
set :port, 3000
enable :sessions
set :session_secret, 'Kim Jong Un riding a unicorn'

get '/' do
  @title = "Welcome to SelfiSite"
  @isLoggedIn = checkLoggedIn()
  erb :home
end

post '/signup' do
    name = params[:name]
    email = params[:email]
    username = params[:username]
    password = params[:password]
    confirmPassword = params[:confirmPassword]
    
    if password == confirmPassword
        UserController.createUser(name, username, email, password)
        setLoggedIn(username)
        redirect '/'
    else
        puts "Passwords don't match!"
    end
end

post '/signin' do
   username = params[:username]
   password = params[:password]
   if UserController.checkUserPassword(username, password)
       setLoggedIn(username)
       redirect '/'
   end
   
end

post '/upload' do
    name = params[:filename]
    filename = "uploads/#{session['loggedIn']}/#{params[:file_upload][:filename]}"
    
    File.open(filename, "wb") do |f|
        f.write(params['file_upload'][:tempfile].read)
    end
  
    UserController.addUserImage(session['loggedIn'], name, filename)
  
    redirect('/')
end

get '/invalidateSession' do
    session.clear
    redirect '/'
end

def checkLoggedIn
    return (session['loggedIn'] != nil) ? true : false
end

def setLoggedIn(username)
    session['loggedIn'] = username
end