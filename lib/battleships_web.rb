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

    ships_hash = {"cruiser" => Ship.cruiser,
                  "submarine"=> Ship.submarine,
                  "destroyer"=> Ship.destroyer,
                  "battleship"=> Ship.battleship,
                  "aircraft carrier"=> Ship.aircraft_carrier}
    ship_type = params[:ship_type]
    coordinate = (params[:x_coord] + params[:y_coord].to_s).to_sym
    orienation = params[:orientation].to_sym

    begin
      $game.player_1.place_ship ships_hash[ship_type], coordinate, orienation
      $ships.delete(ship_type)
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
    placements = random_board_placements
    random_board_placements.each { |ship| $game.player_2.place_ship ship[0],ship[1],ship[2] }
    @opponent_board = $game.opponent_board_view $game.player_1
    $all_coords = (('A'..'J').to_a).product((1..10).to_a).map{|letter, num| letter + num.to_s}
    erb :battle
  end

  post '/battle' do

    computer_shot = $all_coords.sample
    $all_coords.delete(computer_shot)
    shot = (params[:x_coord] + params[:y_coord].to_s).to_sym

    begin

      result_of_your_shot = $game.player_1.shoot shot

      if result_of_your_shot == :miss
        @to_tell = "Your shot missed. Try again"
      elsif result_of_your_shot == :hit
        @to_tell = "You hit a ship!"
      else
        @to_tell = "You just sunk a ship!"
      end

      result_of_computer_shot = $game.player_2.shoot computer_shot.to_sym

      if result_of_computer_shot == :miss
        @to_know = "Your opponent missed"
      elsif result_of_computer_shot == :hit
        @to_know = "Your opponent just hit one of your ships"
      else
        @to_know = "Your opponent just sunk one of your ships!"
      end

    rescue RuntimeError => e
      @do_not_shoot_two_times = e

    end


    @opponent_board = $game.opponent_board_view $game.player_1
    @board = $game.own_board_view $game.player_1

    if $game.has_winner?
      redirect '/game_over'
    end

    erb :battle
  end

  get '/game_over' do
    @message = $game.player_1.winner? ? "You won! :)" : "You lost :("
    erb :game_over
  end

  def random_board_placements

    coords = (('A'..'J').to_a).product((1..10).to_a).map{|letter, num| letter + num.to_s}

    ships = {
          submarine: [Ship.submarine,1],
          destroyer: [Ship.destroyer,2],
          cruiser: [Ship.cruiser,3],
          battleship: [Ship.battleship,4],
          aircraft_carrier: [Ship.aircraft_carrier,5]
        }

    board = []


    while !ships.empty?
      ships.each do |ship_type, ship_info|

        ship_size = ship_info[1]
        starting_point = coords.sample
        orientation = [:horizontally, :vertically].sample
        try_position = create_position(starting_point, ship_size, orientation)

        if coords & try_position == try_position
          board << [ship_info[0], starting_point.to_sym, orientation]
          coords = coords - try_position
          ships.delete(ship_type)
        end

      end
    end
    board
  end


  def create_position starting_point, size, orientation
    positions_array = []
    letter, number = split_coordinate(starting_point)
    to_change = (orientation == :horizontally) ? letter : number
    size.times do
      positions_array << letter + number
      to_change.next!
    end
    positions_array
  end

  def split_coordinate starting_point
    [starting_point.scan(/[A-Z]/).join, starting_point.scan(/[0-9]/).join]
  end


  run! if app_file == $0
end
