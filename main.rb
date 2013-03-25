require "bundler/setup"
require 'pony'
require 'sinatra'
require 'slim'
require 'sass'
require 'sinatra/reloader' if development?
require 'sinatra/flash'
require './song'

set :public_folder, 'public'
set :views, 'views'

configure do
  enable :sessions
  set :username, 'frank'
  set :password, 'sinatra'
end

helpers do
  def css(*stylesheets)
    stylesheets.map do |stylesheet|
      "link href=\"/#{stylesheet}.css\" media=\"screen, projection\" rel=\"stylesheet\" />"
    end.join
  end

  def current?(path='/')
    (request.path==path || request.path==path+'/') ? "current" : nil
  end

  def set_title
    @title ||= "Songs By Sinatra"
  end

  def send_message
    Pony.mail(
      :from => params[:name] + "<" + params[:email] + ">",
      :to => :email_address,
      :subject => params[:name] + " has contacted you",
      :body => params[:message],
      :port => '587',
      :via => :smtp,
      :via_options => {
      :address => 'smtp.gmail.com',
        :port => '587',
        :enable_starttls_auto => true,
        :user_name => :email_user_name,
        :password => :email_password,
        :authentication => :plain,
        :domain => :email_domain
    })
  end
end

before do
  set_title
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

post '/contact' do
  send_message
  flash[:notice] = "Thank you for your message.  We'll be in touch soon."
  redirect to('/')
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

