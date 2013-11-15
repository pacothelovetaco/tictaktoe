require 'bundler/setup'
require 'sinatra'
require 'erb'
require './config/init'
require 'json'

get "/" do
  LOGGER.info('%s: %s' % [request.ip, "GET /"])
  erb :game_index
end


post "/play" do

  # Params
  move   = params[:move].gsub("c", "")
  board  = params[:board] 
  letter = params[:letter]
  
  # Create new object
  @game = TicTacToe.new

  # Set in_game to true by default
  in_game = true

  # Gameplay logic
  # First, make the player's move, then
  # check if game is over. If not, do the same
  # for the computer
  @game.make_move(board, letter, move)
  if @game.winner?(board, letter)
    in_game = false
    winner = "player"
  else
    if @game.board_full?(board)
      in_game = false
      winner = "tie"
    end
  end

  if in_game == true
    computer_move = @game.get_computer_move(board, "O")
    @game.make_move(board, "O", computer_move)
    if @game.winner?(board, "O")
      in_game = false
      winner = "computer"
    else
      if @game.board_full?(board)
        in_game = false
        winner = "tie"
      end
    end
  end
  
  # JSON response
  # 
  # board [Array]: and array with the current moves
  # computer_move [Integer]: The computer's recent move
  # in_game [Boolean]: boolean that dictates the status
  #   of the game. It displays false when there
  #   is a victor.
  # winner [String]: displays the victor. Can either
  # be null, "computer", "player", or "tie"
  #
  { board: board, 
    computer_move: computer_move, 
    in_game: in_game, 
    winner: winner
  }.to_json
end
