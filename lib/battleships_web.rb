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
    $ships = ["cruiser", "submarine", "destroyer", "battleship", "aircraft carrier"]
    erb :place_ships
  end

  post '/place_ships' do
    # $ships = ["cruiser", "submarine", "destroyer", "battleship", "aircraft carrier"]
    ships_hash = {"cruiser" => Ship.cruiser,
                  "submarine"=> Ship.submarine,
                  "destroyer"=> Ship.destroyer,
                  "battleship"=> Ship.battleship,
                  "aircraft carrier"=> Ship.aircraft_carrier}
    @ship_type = params[:ship_type]
    @coordinate = (params[:x_coord] + params[:y_coord].to_s).to_sym
    @orienation = params[:orientation].to_sym

    begin
      $game.player_1.place_ship ships_hash[@ship_type], @coordinate, @orienation
      $ships.delete(@ship_type)
    rescue RuntimeError => e
      @error = e
    end

    @board = $game.own_board_view $game.player_1
    if $ships.empty?
      redirect '/battle'
    end
    erb :place_ships
  end

  get '/battle' do
    @board = $game.own_board_view $game.player_1
    $game.player_2.place_ship Ship.cruiser, :C4, :vertically
    $game.player_2.place_ship Ship.submarine, :H2, :horizontally
    $game.player_2.place_ship Ship.destroyer, :D9, :horizontally
    $game.player_2.place_ship Ship.battleship, :J5, :vertically
    $game.player_2.place_ship Ship.aircraft_carrier, :A1, :horizontally
    @opponent_board = $game.opponent_board_view $game.player_1
    erb :battle
  end

  post '/battle' do
    all_coords = (('A'..'J').to_a).product((1..10).to_a).map{|letter, num| letter + num.to_s}
    computer_shot = all_coords.sample
    @shot = (params[:x_coord] + params[:y_coord].to_s).to_sym
    @result_of_your_shot = $game.player_1.shoot @shot

    if @result_of_your_shot == :miss
      @to_tell = "Your shot missed. Try again"
    elsif @result_of_your_shot == :hit
      @to_tell = "You hit a ship!"
    else
      @to_tell = "You just sunk a ship!"
    end

    @result_of_computer_shot = $game.player_2.shoot computer_shot.to_sym

    if @result_of_computer_shot == :miss
      @to_know = "Your opponent missed"
    elsif @result_of_computer_shot == :hit
      @to_know = "Your opponent just hit one of your ships"
    else
      @to_know = "Your opponent just sunk one of your ships!"
    end

    @opponent_board = $game.opponent_board_view $game.player_1
    @board = $game.own_board_view $game.player_1
    erb :battle
  end


  run! if app_file == $0
end
