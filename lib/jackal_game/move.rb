module JackalGame

  class Move


    attr_reader :unit, :location, :loot
    attr_accessor :tile, :current_move_player_id, :unit_location, :captured_units, :sailors, :loot


    def initialize params
      @current_move_player_id = params['current_move_player_id']
      @action = params['action']
      @unit = params['unit'].to_i
      @location = params['location'].to_i
      @loot = params['loot'].to_i unless params['loot'].empty?
    end
  end
end
