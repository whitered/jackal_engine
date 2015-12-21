module JackalGame

  class Action


    attr_reader :action
    attr_reader :unit
    attr_reader :location
    attr_reader :carried_loot

    attr_accessor :tile
    attr_accessor :current_move_player_id
    attr_accessor :unit_location
    attr_accessor :captured_units
    attr_accessor :sailors
    attr_accessor :found_loot
    attr_accessor :available_steps


    def initialize params
      @current_move_player_id = params['current_move_player_id']
      @action = params['action']
      @unit = params['unit'].to_i
      @location = params['location'].to_i
      @carried_loot = (params['carried_loot'].to_s || '').empty? ? nil : params['carried_loot'].to_i
    end


    def predict_next_action
      return nil if @available_steps.nil?
      return nil if @available_steps.size > 1

      params = {
        current_move_player_id: @current_move_player_id,
        unit: @unit,
        carried_loot: @carried_loot
      }
      if @available_steps.empty?
        params['action'] = 'death'
        params['location'] = @location
      else
        unit = @available_steps.keys.first
        steps = @available_steps.values.first
        return nil if steps.size > 1
        has_loot = steps.keys.first
        steps = steps.values.first
        return nil if steps.size > 1
        params['unit'] = unit
        params['action'] = 'move'
        params['location'] = steps.first
      end

      Action.new params
    end
  end
end
