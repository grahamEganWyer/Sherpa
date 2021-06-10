     
require 'sinatra'
require 'sinatra/reloader' if development?
require 'pg'
require 'pry'
require 'bcrypt'

require_relative "db/helpers.rb"

enable :sessions

def current_user
  run_sql("SELECT * FROM users WHERE id = #{session[:user_id]};")[0]
end

def logged_in?
  if session[:user_id] == nil
    return false
  else
    return true
  end
end


get '/' do
  erb :index
end

get '/show_quest_steps' do

  res = run_sql("SELECT * FROM attunement;").to_a
  # db = PG.connect(ENV['DATABASE_URL'] || {dbname: 'sherpa'})
  # res = (db.exec("SELECT * FROM attunement;")).to_a
  erb :show_quest_steps, locals: { res: res }
end

get '/login' do
  erb :login
end

post "/login" do

  # records = run_sql("SELECT * FROM users WHERE username = '#{params['username']}';")
  records = run_sql("SELECT * FROM users WHERE username = $1;", [params['username']])

  if records.count > 0 && BCrypt::Password.new(records[0]['password_digest']) == params['password']

    logged_in_user = records[0]
    session[:user_id] = logged_in_user["id"]
    redirect '/show_quest_steps'

  else
    erb :login
  end
end

get '/signup' do
  erb :signup
end

post '/signup' do
  # records = run_sql("SELECT * FROM users WHERE username = '#{params['username']}';"
  password_digest = BCrypt::Password.create(params['password'])

  sql = "INSERT INTO users (username, password_digest) VALUES ('#{params['username']}', '#{password_digest}')"

  
  records = run_sql("SELECT * FROM users WHERE username = $1;", [params['username']]).to_a

  binding.pry

  if records.count == 0
    run_sql(sql)
    redirect '/'
  else
    redirect 'signup'    
  end
end

delete '/session' do
  session[:user_id] = nil
  redirect '/'
end





