module JackalGame

  class GameState

    def self.initial options={}
      num_of_players = options[:num_of_players] || 4
      GameState.new do
        map [0] * 121
        players = 1.upto(num_of_players).map { player }
        unit do
          location 1
        end
        unit do
          location 100
        end
      end
    end


    def self.json_create data
      new data
    end


    attr_reader :map, :players, :units, :current_move_player_id


    def initialize data={}, &block
      @map = data['map'] || []

      @players = []
      data['players'].each do |p|
        @players << p
      end if data.has_key?('players')

      @units = []
      data['units'].each do |u|
        @units << u
      end if data.has_key?('units')

      instance_eval &block if block_given?
    end


    def as_json options={}
      { 
        :json_class => self.class.name,
        :map => @map.as_json,
        :players => @players.as_json,
        :units => @units.as_json,
        :current_move_player_id => @current_move_player_id
      }
    end


    def map value
      @map = value
    end


    def player &block
      p = Player.new &block
      p.id = @players.length
      @players << p
    end


    def unit &block
      u = Unit.new &block
      u.id = @units.length
      @units << u
    end


    def start
      @current_move_player_id = 0
    end


    def move action
      return 'wrong turn' unless current_move_player_id == action.current_player
      unit = @units[action.unit]
      location = action.location
      tile = @map[location]
      if tile == 0
        tile = rand(45) + 1
        @map[location] = tile
      end
      action.tile = tile
      unit.location location
      action
    end

  end

end
