#!/usr/bin/env ruby
# encoding: UTF-8
require 'sinatra'
require 'sinatra/sequel'
require 'sinatra/content_for'
require 'slim'
require 'sqlite3'
require 'sass'
require 'identicon'
require 'json'

configure do
  set :database, 'sqlite:///kravet_db'
  puts "Table doesn't exist. Run `sqlite3 kravet_db`." if !database.table_exists?('kravet_db')

  require "./config/data"
  # required "./config/migrations"

  ENV['TZ'] = 'Asia/Manila'

  set :scss, {:style => :compressed, :debug_info => false}

  enable :sessions
  set :session_secret, '740b206810a71246bc0de7fe38c562c1a6dac27b60742742f29d4b3ace039427'
end

before do
  @fishes = [
    ["Bangus", "http://www.ag.auburn.edu/fish/image_gallery/data/media/13/milk.png"],
    ["Shrimp", "http://seafood.vasep.com.vn/pic/news/tom-philippines635134701867671613.jpg"],
    ["Tiger Prawn", "http://img.21food.com/20110609/product/1305723794453.jpg"],
    ["Tilapia", "http://cdn.wn.com/ph/img/fb/19/6509918639ef5a981859c4dc0c59-grande.jpg"],
    ["Lapu Lapu", "http://photos1.blogger.com/blogger/1034/3479/1600/ss.2.jpg"],
    ["Mudcrab", "http://s3.amazonaws.com/readers/2012/12/10/dsc02670_1.jpg"],
    ["Tulingan", "http://www.bohol.ph/pics/large/IMG_0650.jpg"],
    ["Tuna", "http://seaeaglemarket.com/wp-content/uploads/2012/03/yellowfin_tuna.jpg"],
    ["Seaweed", "http://www.abc.net.au/reslib/201301/r1059099_12387598.jpg"],
    ["Crab", "http://img.21food.com/20110609/product/1305080420593.jpg"],
    ["Pusit", "http://www.delmonte.ph/sites/default/files/image/kitchenomics/ingredients/main_image/main_squid.png"],
    ["Galunggong", "http://www.interaksyon.com/assets/images/articles/interphoto_1328324551.jpg"],
    ["Sea Cucumber", "https://eagronfiles.files.wordpress.com/2010/06/sea-cucumber4.jpg"],
  ]
end

get '/css/:name.css' do |name|
  content_type :css
  scss "sass/#{name}".to_sym, :layout => false
end

get '/' do
  slim :index
end

get '/search' do
  @query = params[:query]

  @available = [true, false].sample
  @quantity = 10000
  @suggestions = "Tuna"

  slim :search
end

get '/detail/:fish_id' do

end
