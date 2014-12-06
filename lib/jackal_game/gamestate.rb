module JackalGame

  class GameState

    def self.initial
      GameState.new do
        map [0] * 121
        p1 = player
        unit do
          location 115
        end
        unit do
          location 100
        end
      end
    end


    def self.json_create data
      new data
    end


    attr_reader :map, :players, :units


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
        :units => @units.as_json
      }
    end


    def map value
      @map = value
    end


    def player &block
      p = Player.new &block
      @players << p
    end


    def unit &block
      u = Unit.new(&block)
      u.id = @units.length
      @units << u
    end



    def move action
      unit = @units[action.unit]
      location = action.location
      unit.location location
    end

  end

end
