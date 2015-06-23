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
    erb :place_ships
  end

  post '/place_ships' do
    ships_hash = {"cruiser" => Ship.cruiser,
                  "submarine"=> Ship.submarine,
                  "destroyer"=> Ship.destroyer,
                  "battleship"=> Ship.battleship,
                  "aircraft_carrier"=> Ship.aircraft_carrier}
    @ship_type = params[:ship_type]
    @coordinate = params[:coordinate].to_sym
    @orienation = params[:orientation].to_sym
    $game.player_1.place_ship ships_hash[@ship_type], @coordinate, @orienation
    @board = $game.own_board_view $game.player_1
    erb :place_ships
  end



  run! if app_file == $0
end
