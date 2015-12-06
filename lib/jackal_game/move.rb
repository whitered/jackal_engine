module JackalGame

  class Move


    attr_reader :unit, :location, :carried_loot
    attr_accessor :tile, :current_move_player_id, :unit_location, :captured_units, :sailors, :found_loot, :current_move_unit_id, :available_steps


    def initialize params
      @current_move_player_id = params['current_move_player_id']
      @action = params['action']
      @unit = params['unit'].to_i
      @location = params['location'].to_i
      @carried_loot = params['carried_loot'].to_i unless params['carried_loot'].empty?
    end
  end
end
