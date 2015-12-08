module JackalGame

  class GameState

    def self.initial options={}
      num_of_players = options[:num_of_players] || 4
      map_size = 13

      map = Map.generate('size' => map_size)

      players = 0.upto(num_of_players - 1).map { |id| Player.new('id' => id) }

      units = []

      players.each do |player|
        location = map.spawn player.id
        units << Unit.new('location' => location, 'player_id' => player.id, 'type' => 'ship')
        3.times { units << Unit.new('location' => location, 'player_id' => player.id, 'type' => 'pirate') }
      end

      units.each_with_index { |u, i| u.id = i }

      data = {
        'map' => map,
        'players' => players,
        'units' => units
      }

      GameState.new data
    end


    def self.json_create data
      new data
    end


    attr_reader :map, :players, :units, :loot, :current_move_player_id,
      :current_move_unit_id, :current_move_unit_available_steps


    def initialize data={}
      @map = data['map'] || Map.new 
      @players = data['players'] || []
      @units = data['units'] || []
      @loot = data['loot'] || [] 
      @current_move_player_id = data['current_move_player_id']
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
        :current_move_unit_id => @current_move_unit_id,
        :current_move_unit_available_steps => @current_move_unit_available_steps
      }
    end


    def start
      @current_move_player_id = 0
    end


    def move action
      steps = []
      unit = @units[action.unit]
      path_finder = PathFinder.new self, unit

      loop do
        steps << make_step(action, path_finder)
        @current_move_unit_id = action.current_move_unit_id
        @current_move_unit_available_steps = action.current_move_unit_available_steps
        @current_move_player_id = action.current_move_player_id

        break if @current_move_unit_id.nil? or @current_move_unit_available_steps.size > 1
        break if steps.last.is_a? String
        break if steps.size > 100

        @current_move_unit_available_steps.delete action.location if action.unit_location != action.location

        if @current_move_unit_available_steps.empty?
          steps << "no way"
          break
        end

        if @current_move_unit_available_steps.size == 1
          action = JackalGame::Move.new({
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

      unit = @units[action.unit]
      return 'wrong player' unless unit.player_id == current_move_player_id
      return 'wrong unit' if @current_move_unit_id.present? and @current_move_unit_id != unit.id

      location = action.location
      return 'wrong step' if @current_move_unit_available_steps.present? and !@current_move_unit_available_steps.include? location

      tile = @map.at(location)
      carried_loot = @loot[action.carried_loot] if action.carried_loot
      return 'inaccessible tile' unless tile.accessible?(unit, carried_loot)

      unless tile.explored?
        @map.open_tile(location)
        tile = @map.at(location)
        action.tile = tile.value
        found_loot = tile.get_loot
        if found_loot
          lid = @loot.size
          @loot.concat found_loot.map { |l| l.location = location; l.id = lid; lid += 1; l }
          action.found_loot = found_loot.map { |l| { id: l.id, location: location, type: l.type } }
        end
      end

      captured_units = @units.select{ |unit| unit.location == location && unit.player_id != current_move_player_id }
      captured_units.each do |unit|
        captured_ship = @units.select { |u| u.player_id == unit.player_id && u.type == 'ship' }.first
        unit.location = captured_ship.location
      end
      action.captured_units = captured_units.map(&:id)

      prev_location = unit.location

      if tile.accessible?(unit, carried_loot)
        if unit.ship?
          sailors = @units.select{ |u| u.location == unit.location && u != unit }
          sailors.each { |u| u.location = location }
          action.sailors = sailors.map(&:id)
        end

        unit.location = location
        action.unit_location = location
        carried_loot.location = location unless carried_loot.nil?
      end

      tile = @map.at unit.location

      if tile.transit?
        steps = path_finder.find_next_steps prev_location, location, carried_loot

        action.current_move_unit_id = unit.id
        action.current_move_unit_available_steps = steps
      else
        next_player_id = (action.current_move_player_id + 1) % players.size

        action.current_move_unit_id = nil
        action.current_move_unit_available_steps = nil
        action.current_move_player_id = next_player_id
      end

      action
    end

  end
end
