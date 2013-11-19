class TicTacToe

  BOARD_RANGE = 0..8

  ##
  # Places a move on the board
  #
  # @param [Array] board
  #   the current playing board
  #
  # @param [String] letter
  #   the letter being played
  #
  # @param [Integer] move
  #   the move that corresponds to an element in the board array
  #
  # @return [void]
  def make_move(board, letter, move)
    board[move.to_i] = letter
  end
  
  ##
  # Checks whether the space is available before making a move
  #
  # @param [Array] board
  #  the current playing board
  #
  # @param [Integer] move
  #   the move that corresponds to an element in the board array
  # 
  # return [Boolean]
  #   true or false whether the space is available
  def space_available?(board, move)
    board[move.to_i] == ""
  end
  
  ##
  # Checks if there is a winner with 3 letters in a row
  #
  # @param [Array] board
  #   the current playing board
  #
  # @param [String] letter
  #   the letter being played
  #
  # @return [Boolean]
  def winner?(board, letter)
    # check top across
    if (board[6] == letter and board[7] == letter and board[8] == letter) then return true end
    # check middle across
    if(board[3] == letter and board[4] == letter and board[5] == letter) then return true end
    # check bottom across
    if(board[0] == letter and board[1] == letter and board[2] == letter) then return true end
    # check left side
    if(board[6] == letter and board[3] == letter and board[0] == letter) then return true end
    # check middle
    if(board[7] == letter and board[4] == letter and board[1] == letter) then return true end
    # check right side
    if(board[8] == letter and board[5] == letter and board[2] == letter)then return true end
    # diagnol
    if(board[6] == letter and board[4] == letter and board[2] == letter)then return true end
    # diagnol
    if(board[8] == letter and board[4] == letter and board[0] == letter)then return true end
    false
  end

  ##
  # Checks if the board is full
  #
  # @param [Array] board
  #   the current playing board
  # 
  # @return [Boolean]
  #   true if the board is full or false if it is not
  def board_full?(board)
    !board.include?("")
  end

  ##
  # The brains for the computer
  #
  # The computer will attempt to first try to win. Next, it will
  # try to block the player. If both fail, then it will check to see
  # where the player has moved and attempt to take a corner or 
  # the center accordingly. See http://www.wikihow.com/Win-at-Tic-Tac-Toe 
  # for more.
  #
  # @param [Array] board
  #   the current playing board
  #
  # @param [String] computer_letter
  #  the computer's letter
  #
  # @return [Integer]
  #  the computer's next move
  def get_computer_move(board, computer_letter)
    # Straghten out the letters in play
    if computer_letter == 'X'
      player_letter = 'O'
    else
      player_letter = 'X'
    end
    
    # First, check if the computer can win in the next move
    (BOARD_RANGE).each do |i|
      copy = copy_board(board)
      if space_available?(copy, i)
        make_move(copy, computer_letter, i)
        if winner?(copy, computer_letter)
          return i
        end
      end
    end
    
    # Block the player if he is going to win
    (BOARD_RANGE).each do |i|
      copy = copy_board(board)
      if space_available?(copy, i)
        make_move(copy, player_letter, i)
        if winner?(copy, player_letter)
          return i
        end
      end
    end
    
    # Check to see if the player has made a strategic move.
    # If player chose center, take a corner
    if board[4] == player_letter
      move = choose_random_move(board, [0, 2, 6, 8])
      if move != nil
        return move
      end
    end

    # If player chose corner, take the center
    if board[0] == player_letter ||
      board[2] == player_letter ||
      board[6] == player_letter ||
      board[8] == player_letter

      if space_available?(board, 4)
        return 4
      else
        return choose_random_move(board, [1, 3, 5, 7])
      end
    end

    # ...else, the computer will make a strategic move.
    # Take corner first
    move = choose_random_move(board, [0, 2, 6, 8])
    if move != nil
      return move
    end
    
    # Take center
    if space_available?(board, 4)
      return 4
    end
    
    # All else fails, take a side
    choose_random_move(board, [1, 3, 5, 7])
  end

  ##
  # Duplicates the playing board to test next moves
  #
  # @param [Array] board
  #   the current playing board
  #
  # return [Array]
  #   the board duplicated
  def copy_board(board)
    board.dup
  end

  ##
  # If the computer can't win, choose a random move if it is available
  #
  # @param [Array] board
  #   the current playing board
  #
  # @param [Array] list_of_moves
  #  a list of possible moves
  #
  # @return [Integer]
  #  a random number from the list_of_moves. Returns nil if none of the moves
  #  are empty.
  def choose_random_move(board, list_of_moves)
    possible_moves = []
    list_of_moves.each do |move|
      if space_available?(board, move)
        possible_moves << move
      end
    end
  
    if possible_moves.count != 0
      possible_moves.sample
    else
      nil
    end
  end
end # // class end
