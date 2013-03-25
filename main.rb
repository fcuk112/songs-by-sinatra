require "bundler/setup"
require 'sinatra'
require 'slim'
require 'sass'
require 'sinatra/reloader' if development?
require './song'

set :public_folder, 'public'
set :views, 'views'

configure do
  enable :sessions
  set :username, 'frank'
  set :password, 'sinatra'
end

get '/set/:name' do
  session[:name] = params[:name]
end

get '/get/hello' do
  "Hello #{session[:name]}"
end

get('/styles.css'){ scss :styles }

get '/' do
  slim :home
end

get '/about' do
  @title = "All About This Website"
  slim :about
end

get '/contact' do
  slim :contact
end

get '/instance' do
  @name = "DAZ"
  slim :show
end

not_found do
  slim :not_found
end

get '/login' do
  slim :login
end

post '/login' do
  if params[:username] == settings.username && params[:password] == settings.password
    session[:admin] = true
    redirect to('/songs')
  else
    slim :login
  end
end

get '/logout' do
  session.clear
  redirect to('/login')
end


__END__

@@show
<h1>Hello <%= @name %>!</h1>

