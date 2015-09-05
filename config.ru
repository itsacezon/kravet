# encoding: UTF-8
require 'sass/plugin/rack'
require './kravet'

use Sass::Plugin::Rack
run Sinatra::Application
