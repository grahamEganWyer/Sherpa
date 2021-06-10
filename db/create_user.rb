require 'bcrypt'

require_relative 'helpers.rb'

username = 'beastheart'
password = 'pudding'

password_digest = BCrypt::Password.create(password)

sql = "INSERT INTO users (username, password_digest) VALUES ('#{username}', '#{password_digest}')"


run_sql(sql [params['username'], params['password_digest']])

