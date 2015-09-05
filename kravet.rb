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
  puts "Table doesn't exist. Run `sqlite3 kravet_db`." if !database.table_exists?('kravet_db')

  # require "./config/data"

  ENV['TZ'] = 'Asia/Manila'

  set :scss, {:style => :compressed, :debug_info => false}

  enable :sessions
  set :session_secret, '740b206810a71246bc0de7fe38c562c1a6dac27b60742742f29d4b3ace039427'
end

get '/css/:name.css' do |name|
  content_type :css
  scss "sass/#{name}".to_sym, :layout => false
end

get '/' do
  slim :index
end
