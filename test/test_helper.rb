ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'minitest/benchmark'
require 'rack/test'

require File.expand_path '../../app.rb', __FILE__

set :environment, :test

def game
  @game ||= TicTacToe.new
end
