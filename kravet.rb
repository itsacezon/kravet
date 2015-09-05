#!/usr/bin/env ruby
# encoding: UTF-8
require 'sinatra'
require 'sinatra/sequel'
require 'sinatra/content_for'
require 'slim'
require 'sqlite3'
require 'sass'
require 'identicon'

configure do
  set :database, 'sqlite:///kravet_db'
  puts "Table doesn't exist" if !database.table_exists?('foos')

  # require "./config/data"

  ENV['TZ'] = 'Asia/Manila'

  set :scss, {:style => :compressed, :debug_info => false}

  enable :sessions
  set :session_secret, '$2a$10$NYB.Sk0xxjDIpTvztIAn7.8Max3BXCLLnEzTSUZ3ghM2.PHAD3c0G'
end

get '/css/:name.css' do |name|
  content_type :css
  scss "sass/#{name}".to_sym, :layout => false
end

get '/' do
  slim :index
end
