require 'sinatra/base'
require 'battleships'

class BattleshipsWeb < Sinatra::Base

  set :views, proc { File.join(root, '..', 'views') }

  get '/' do
    erb :index
  end

  get '/start' do
    $visitor = params[:name]
    if $visitor
      $game = Game.new Player, Board
      @board = $game.own_board_view $game.player_1
      erb :welcome
    else
      erb :start
    end
  end

  get '/place_ships' do
    @ships = ["cruiser", "submarine", "destroyer", "battleship", "aircraft carrier"]
    erb :place_ships
  end

  post '/place_ships' do
    @ships = ["cruiser", "submarine", "destroyer", "battleship", "aircraft carrier"]
    ships_hash = {"cruiser" => Ship.cruiser,
                  "submarine"=> Ship.submarine,
                  "destroyer"=> Ship.destroyer,
                  "battleship"=> Ship.battleship,
                  "aircraft carrier"=> Ship.aircraft_carrier}
    @ship_type = params[:ship_type]
    @ships.delete(@ship_type)
    @coordinate = (params[:x_coord] + params[:y_coord].to_s).to_sym
    @orienation = params[:orientation].to_sym
    $game.player_1.place_ship ships_hash[@ship_type], @coordinate, @orienation
    @board = $game.own_board_view $game.player_1
    erb :place_ships
  end

  get '/battle' do
    erb :battle
  end



  run! if app_file == $0
end
