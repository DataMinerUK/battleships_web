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
    $ships = ["cruiser", "submarine", "destroyer", "battleship", "aircraft_carrier"]
    erb :place_ships
  end

  post '/place_ships' do

    ship_type = params[:ship_type]
    coordinate = (params[:x_coord] + params[:y_coord])
    orientation = params[:orientation]

    begin
      $game.player_1.place_ship Ship.send(ship_type), coordinate, orientation
      $ships.delete(ship_type)
    rescue RuntimeError => @error
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
    your_shot = params[:x_coord] + params[:y_coord]

    begin

      result_of_your_shot = $game.player_1.shoot your_shot.to_sym
      @to_tell = message_from_your_shot result_of_your_shot

      result_of_computer_shot = $game.player_2.shoot computer_shot.to_sym
      @to_know = message_from_computer_shot result_of_computer_shot
      $all_coords.delete(computer_shot)

    rescue RuntimeError => @do_not_shoot_two_times

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

  def message_from_your_shot shot
    if shot == :miss
      "Your shot missed. Try again"
    elsif shot == :hit
      "You hit a ship!"
    else
      "You just sunk a ship!"
    end
  end

  def message_from_computer_shot shot
    if shot == :miss
      "Your opponent missed"
    elsif shot == :hit
      "Your opponent just hit one of your ships"
    else
      "Your opponent just sunk one of your ships!"
    end
  end

  def random_board_placements

    coords = (('A'..'J').to_a).product((1..10).to_a).map{|letter, num| letter + num.to_s}

    ships = [ [Ship.submarine,1],
              [Ship.destroyer,2],
              [Ship.cruiser,3],
              [Ship.battleship,4],
              [Ship.aircraft_carrier,5]
            ]

    board = []


    while !ships.empty?
      ships.each do |ship_info|

        ship_size = ship_info[1]
        starting_point = coords.sample
        orientation = [:horizontally, :vertically].sample
        try_position = create_position(starting_point, ship_size, orientation)

        if coords & try_position == try_position
          board << [ship_info[0], starting_point.to_sym, orientation]
          coords = coords - try_position
          ships.delete(ship_info)
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
