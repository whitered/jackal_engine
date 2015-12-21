module JackalGame

  class Gamestate

    def self.json_create data
      new data
    end


    attr_reader :map, :players, :units, :loot, :current_move_player_id, :available_steps,
      :current_move_unit_id, :current_move_unit_available_steps

    attr_accessor :source_map


    def initialize data={}
      @map = data['map'] || Map.new 
      @players = data['players'] || []
      @units = data['units'] || []
      @loot = data['loot'] || [] 
      @current_move_player_id = data['current_move_player_id']
      @available_steps = data['available_steps']
      @current_move_unit_id = data['current_move_unit_id']
      @current_move_unit_available_steps = data['current_move_unit_available_steps']
    end


    def as_json options={}
      { 
        :json_class => self.class.name,
        :map => @map.as_json,
        :players => @players.as_json,
        :units => @units.as_json,
        :loot => @loot.as_json,
        :current_move_player_id => @current_move_player_id,
        :available_steps => @available_steps,
        :current_move_unit_id => @current_move_unit_id,
        :current_move_unit_available_steps => @current_move_unit_available_steps
      }
    end


    def get_unit uid
      @units.find { |u| u.id == uid }
    end


    def start
      @current_move_player_id = 0
      @available_steps = PathFinder.new(self).get_available_steps(@current_move_player_id)
    end


    def move action
      steps = []
      unit = @units.find { |u| u.id == action.unit}
      path_finder = PathFinder.new self

      loop do
        steps << make_step(action, path_finder)
        @current_move_unit_id = action.current_move_unit_id
        @current_move_unit_available_steps = action.current_move_unit_available_steps
        @current_move_player_id = action.current_move_player_id

        break if @current_move_unit_id.nil? or @current_move_unit_available_steps.size > 1
        break if steps.last.is_a? String

        if steps.size > 100 or @current_move_unit_available_steps.empty?
          action = JackalGame::Action.new({
            'action' => 'death',
            'unit' => action.unit,
            'location' => unit.location,
            'carried_loot' => action.carried_loot,
            'current_move_player_id' => action.current_move_player_id
          })

        elsif @current_move_unit_available_steps.size == 1
          action = JackalGame::Action.new({
            'action' => 'move',
            'unit' => action.unit,
            'location' => @current_move_unit_available_steps.first,
            'carried_loot' => action.carried_loot,
            'current_move_player_id' => action.current_move_player_id
          })
        end
      end

      steps
    end


    def make_step action, path_finder
      return 'wrong turn' unless current_move_player_id == action.current_move_player_id

      unit = @units.find { |u| u.id == action.unit }
      return 'wrong player' unless unit.player_id == current_move_player_id
      return 'wrong unit' if !@current_move_unit_id.nil? and @current_move_unit_id != unit.id


      next_player_id = (action.current_move_player_id + 1) % players.size

      if action.action == 'death'
        @units.delete_if { |u| u.id == unit.id }
        @loot.delete_if { |l| l.id == action.carried_loot } unless action.carried_loot.nil? 
        action.current_move_player_id = next_player_id
        return action
      end

      location = action.location
      unit_steps = @available_steps[unit.id]
      return 'wrong unit' if unit_steps.nil?

      carried_loot = @loot.find { |l| l.id == action.carried_loot } if action.carried_loot
      return 'wrong step' unless unit_steps[!!carried_loot].include? location

      tile = @map.at(location)

      unless tile.explored?
        @map.set_tile(location, @source_map[location])
        tile = @map.at(location)
        action.tile = tile.value
        found_loot = tile.get_loot
        if found_loot
          lid = @loot.size
          @loot.concat found_loot.map { |l| l.location = location; l.id = lid; lid += 1; l }
          action.found_loot = found_loot.map { |l| { id: l.id, location: location, type: l.type } }
        end
      end

      captured_units = @units.select{ |u| !u.nil? and u.location == location and u.player_id != current_move_player_id }
      captured_units.each do |cu|
        captured_ship = @units.find { |u| u.player_id == cu.player_id && u.type == 'ship' }
        cu.location = captured_ship.location
      end
      action.captured_units = captured_units.map(&:id)

      prev_location = unit.location

      if unit.ship?
        sailors = @units.select{ |u| u.location == unit.location && u != unit }
        sailors.each { |u| u.location = location }
        action.sailors = sailors.map(&:id)
      end

      unit.location = location
      action.unit_location = location
      carried_loot.location = location unless carried_loot.nil?

      if tile.transit?
        steps = path_finder.find_next_steps unit, prev_location, location, carried_loot

        action.current_move_unit_id = unit.id
        action.current_move_unit_available_steps = steps
      elsif path_finder.tile_accessible?(tile.type, unit.ship?, carried_loot)
        action.current_move_unit_id = nil
        action.current_move_unit_available_steps = nil
        action.current_move_player_id = next_player_id
      else
        path_finder.ban prev_location, location
        action.current_move_unit_id = unit.id
        action.current_move_unit_available_steps = [prev_location]
      end
      action
    end

  end
end
