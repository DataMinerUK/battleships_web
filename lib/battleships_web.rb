require 'sinatra/base'
require 'battleships'

class BattleshipsWeb < Sinatra::Base

  enable :sessions

  set :views, proc { File.join(root, '..', 'views') }

  PLAYERS = ['player_2', 'player_1']

  get '/' do
    erb :index
  end

  get '/start' do
    @visitor = params[:name]
    if @visitor
      $game ||= Game.new Player, Board
      assign_player unless PLAYERS.empty?
      @board = $game.own_board_view $game.send(session[:player])
      erb :welcome
    else
      erb :start
    end
  end

  get '/place_ships' do
    $ships = ["cruiser", "submarine", "destroyer", "battleship", "aircraft_carrier"]
    @board = $game.own_board_view $game.send(session[:player])
    erb :place_ships
  end

  post '/place_ships' do

    ship_type = params[:ship_type]
    coordinate = params[:x_coord] + params[:y_coord]
    orientation = params[:orientation]

    begin
      $game.send(session[:player]).place_ship Ship.send(ship_type), coordinate, orientation
      $ships.delete(ship_type)
    rescue RuntimeError => @error
    end

    @board = $game.own_board_view $game.send(session[:player])

    if $ships.empty?
      redirect '/battle'
    end
    erb :place_ships
  end

  get '/battle' do
    @board = $game.own_board_view $game.send(session[:player])
    @opponent_board = $game.opponent_board_view $game.send(session[:player])

    erb :battle
  end

  post '/battle' do

    your_shot = params[:x_coord] + params[:y_coord]

    begin

      result_of_your_shot = $game.send(session[:player]).shoot your_shot.to_sym
      @to_tell = message_from_your_shot result_of_your_shot

    rescue RuntimeError => @do_not_shoot_two_times

    end

    @opponent_board = $game.opponent_board_view $game.send(session[:player])
    @board = $game.own_board_view $game.send(session[:player])

    if $game.has_winner?
      redirect '/game_over'
    end

    erb :battle
  end

  get '/game_over' do
    @message = $game.send(session[:player]).winner? ? "You won! :)" : "You lost :("
    erb :game_over
  end

  helpers do

    def assign_player
      session[:player] = PLAYERS.pop
    end

    def message_from_your_shot shot
      if shot == :miss
        "Your shot missed. Try again"
      elsif shot == :hit
        "You hit a ship!"
      else
        "You just sunk a ship!"
      end
    end

    def message_from_opponent_shot shot
      if shot == :miss
        "Your opponent missed"
      elsif shot == :hit
        "Your opponent just hit one of your ships"
      else
        "Your opponent just sunk one of your ships!"
      end
    end
  end

  run! if app_file == $0
end
