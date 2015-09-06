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
  @regions = {
    "NCR" => [14.6090537, 121.02225650000003],
    "CAR" => [17.3512542, 121.17188510000005],
    "I" => [16.0832144, 120.61998949999997],
    "II" => [16.9753758, 121.81070790000001],
    "III" => [15.4827722, 120.7120023],
    "IV-A" => [14.1007803, 121.07937049999998],
    "IV-B" => [9.843206499999999, 118.73647830000004],
    "V" => [13.4209885, 123.41367360000004],
    "VI" => [11.0049836, 122.53727409999999],
    "VII" => [10.2968562, 123.8886774],
    "VIII" => [12.2445533,125.03881639999997],
    "IX" => [6.7073376,121.97537540000008],
    "X" => [8.020163499999999,124.68565089999993],
    "XI" => [7.3041622,126.08934060000001],
    "XII" => [6.2706918,124.68565089999993],
    "CARAGA" => [8.801456199999999,125.74068820000002],
    "ARMM" => [6.956831299999999,124.2421597]
  }

  file = File.read('data.json')
  @fishes = JSON.parse(file)
end

helpers do
  def truncate_words(text, length, end_string = ' ...')
    words = text.split()
    words = words[0..(length-1)].join(' ') + (words.length > length ? end_string : '')
  end
end


get '/css/:name.css' do |name|
  content_type :css
  scss "sass/#{name}".to_sym, :layout => false
end

get '/' do
  slim :index
end

get '/search' do
  query = params[:query]

  @fish = @fishes.sample


  slim :search
end

get '/detail/:fish_id' do
  query = params[:fish_id]

  @available = [true, false].sample
  @fish = @fishes[query.to_i]

  slim :detail
end

get '/fishy' do
  erb :try_it
end

__END__

@@ try_it
<html>
  <head>
    <meta http-equiv="content-type" content="text/html;charset=utf-8">
    <title>Text Fisher</title>
    <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>

  </head>

  <body>
    <form action="/fishery" method="post">
      <label>Enter your CONTACT NUMBER:</label>
      <input id="number" name="user" type="text" placeholder="639xxxxxxxxx">
      <input id="submit" type="submit" value="Do it!">
    </form>

    <script type="text/javascript">
      $(function (){
        $('#submit').on('click', function(ev){
          ev.preventDefault()
          $.ajax({
              url: "https://post.chikka.com:443/smsapi/request",
              type: "POST",
              data: "&message_type=SEND&mobile_number=63"+ $('#number').val() +"&shortcode=292907474&message_id=1231425&message=Hi Senen!" + "&client_id=f04e63f1d6773d56180946f4ee05b578953740a5c4b672cb2453488197ae5678&secret_key=6ac97796f5749f9dc012280add29bd2f1fec4d331ab7dc49aa627b64369be29e",
              dataType: "json",
              success: function(result){
              console.log(result);
            },
            error: function(err){
              console.log(err);
              }
          });
        });
      });
    </script>
  </body>
</html>
