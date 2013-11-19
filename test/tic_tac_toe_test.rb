
require File.expand_path '../test_helper.rb', __FILE__

class TicTacToeTest < MiniTest::Unit::TestCase

  def setup
    @board = ["", "", "", "", "", "", "", "", ""]
  end

  def test_can_make_move
    move = 1
    letter = "X"
    result = game.make_move(@board, letter, move)
    assert_equal(result[0], "X")
  end

  def test_can_get_board_is_full
    full_board = Array.new(9, "X")
    result = game.board_full?(full_board)
    assert_equal(true, result)
  end
  
  #
  # Test Winning moves
  #

  def test_can_find_winner_across_top
    @board[6] = "X"
    @board[7] = "X"
    @board[8] = "X"
    result = game.winner?(@board, "X")
    assert_equal(true, result)
  end

  def test_can_find_winner_across_middle
    @board[3] = "X"
    @board[4] = "X"
    @board[5] = "X"
    result = game.winner?(@board, "X")
    assert_equal(true, result)
  end

  def test_can_find_winner_across_bottom
    @board[0] = "X"
    @board[1] = "X"
    @board[2] = "X"
    result = game.winner?(@board, "X")
    assert_equal(true, result)
  end
  
  def test_can_find_winner_down_left_side
    @board[6] = "X"
    @board[3] = "X"
    @board[0] = "X"
    result = game.winner?(@board, "X")
    assert_equal(true, result)
  end
  
  def test_can_find_winner_down_middle
    @board[7] = "X"
    @board[4] = "X"
    @board[1] = "X"
    result = game.winner?(@board, "X")
    assert_equal(true, result)
  end
  
  def test_can_find_winner_down_right_side
    @board[8] = "X"
    @board[5] = "X"
    @board[2] = "X"
    result = game.winner?(@board, "X")
    assert_equal(true, result)
  end
  
  def test_can_find_winner_diagonal_1
    @board[6] = "X"
    @board[4] = "X"
    @board[2] = "X"
    result = game.winner?(@board, "X")
    assert_equal(true, result)
  end
  
  def test_can_find_winner_diagonal_2
    @board[8] = "X"
    @board[4] = "X"
    @board[0] = "X"
    result = game.winner?(@board, "X")
    assert_equal(true, result)
  end


  #
  # Computer AI
  #
  
  def test_can_copy_board
    @board[1] = "X"
    result = game.copy_board(@board)
    assert_equal(true, @board == result)
  end

  def test_can_check_if_space_is_available
    @board[1] = "X"
    free_space = game.space_available?(@board, 0)
    assert_equal(true, free_space)
    no_free_space = game.space_available?(@board, 1)
    assert_equal(false, no_free_space)
  end

  def test_can_choose_random_move
    @board[1] = "X"
    random_move = game.choose_random_move(@board, [0])
    assert_equal(0, random_move)
    no_random_move = game.choose_random_move(@board, [1])
    assert_equal(nil, no_random_move)
  end

  def test_computer_can_block_player
    @board[8] = "X"
    @board[5] = "X"
    result = game.get_computer_move(@board, "O")
    assert_equal(2, result)
  end

  def test_computer_can_make_winning_move
    @board[6] = "O"
    @board[4] = "O"
    result = game.get_computer_move(@board, "O")
    assert_equal(2, result)
  end

  def test_computer_takes_corner_if_player_took_center
    @board[4] = "X"
    corner_moves = [0, 2, 6, 8]
    result = game.get_computer_move(@board, "O")
    assert_equal(true, corner_moves.include?(result))
  end

  def test_computer_takes_center_if_player_takes_corner
   @board[0] = "X"
   result = game.get_computer_move(@board, "O")
   assert_equal(4, result)
  end
end
