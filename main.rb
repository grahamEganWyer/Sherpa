     
require 'sinatra'
require 'sinatra/reloader' if development?
require 'pg'
require 'pry' if development?
require 'bcrypt'

require_relative "db/helpers.rb"

get '/' do
  erb :index
end

get '/show_quest_steps' do
  db = PG.connect(ENV['DATABASE_URL'] || {dbname: 'sherpa'})
  res = (db.exec("SELECT * FROM attunement;")).to_a
  binding.pry
  erb :show_quest_steps, locals: { res: res }
end

get '/login' do
  erb :login
end

post "/login" do

  records = run_sql("SELECT * FROM users WHERE username = '#{params['username']}';")

  if records.count > 0 && BCrypt::Password.new(records[0]['password_digest']) == params['password']
    redirect '/'

  else
    erb :login
  end
end

get '/signup' do
  erb :signup
end

put '/signup' do
  records = run_sql("SELECT * FROM users WHERE username = '#{params['username']}';")
  if 
end





