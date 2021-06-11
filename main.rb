     
require 'sinatra'
require 'sinatra/reloader' if development?
require 'pg'
require 'pry' if development?
require 'bcrypt'

require_relative "db/helpers.rb"

enable :sessions

def current_user
  run_sql("SELECT * FROM users WHERE id = #{session[:user_id]};")
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
  res = run_sql("SELECT * FROM steps;").to_a
  # db = PG.connect(ENV['DATABASE_URL'] || {dbname: 'sherpa'})
  # res = (db.exec("SELECT * FROM attunement;")).to_a
  erb :show_quest_steps, locals: { res: res }
end

post '/show_quest_steps' do
  sql = "UPDATE users SET steps_completed[#{params["id"]}] = '#{params["id"]}' WHERE id = #{current_user[0]["id"]};"
  run_sql(sql)
  redirect '/show_quest_steps'
end



get '/login' do
  erb :login
end

post "/login" do

  records = run_sql("SELECT * FROM users WHERE username = '#{params['username']}';")
  # records = run_sql("SELECT * FROM users WHERE username = $1;", [params['username']])

  if records.count > 0 && BCrypt::Password.new(records[0]['password_digest']) == params['password']

    logged_in_user = records[0]
    session[:user_id] = logged_in_user["id"]
    session[:username] = logged_in_user["username"]
    redirect '/show_quest_steps'

  else
    erb :login
  end
end

get '/signup' do
  erb :signup
end

post '/signup' do
  records = run_sql("SELECT * FROM users WHERE username = '#{params['username']}';").to_a
  password_digest = BCrypt::Password.create(params['password'])
  user_level = params['user_level'].to_i
  sql = "INSERT INTO users (username, password_digest, user_level, steps_completed[0]) VALUES ('#{params['username']}', '#{password_digest}', '#{user_level}', #{0})"

  
  # records = run_sql("SELECT * FROM users WHERE username = $1;", [params['username']]).to_a

  if records.count == 0
    run_sql(sql)
    redirect '/login'
  else
    redirect '/signup'    
  end
end

delete '/session' do
  session[:user_id] = nil
  redirect '/'
end





