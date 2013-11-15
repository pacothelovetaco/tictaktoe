require File.expand_path '../test_helper.rb', __FILE__
require "json"

class AppTest < MiniTest::Unit::TestCase

  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def setup
    @board = ["", "", "", "", "", "", "", "", ""]
  end

  def test_get_index
    get '/'
    assert last_response.ok?
  end

  def test_post_play
    post "/play", params = {board: @board, move: "c1", letter: "X"}
    
    response = JSON.parse(last_response.body)
    new_board = response["board"]
    assert_equal "X", new_board[1]
    assert_equal true, new_board.include?("O")
    refute_nil response["computer_move"]
    assert_equal true, response["in_game"]
    assert_equal nil, response["winner"]
  end

end
