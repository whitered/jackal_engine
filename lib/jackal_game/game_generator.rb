module JackalGame

  class GameGenerator

    include JackalGame
    include TileConstants


    def self.map options={}
      size = options[:size] || 13
      unexplored = options[:unexplored]
      gen = GameGenerator.new size, unexplored
      gen.map
    end


    def self.gamestate options={}
      num_of_players = options[:num_of_players] || 4
      map_size = options[:size] || 13

      tiles = GameGenerator.map(size: map_size, unexplored: true)
      map = Map.new({ 'tiles' => tiles, 'size' => map_size })

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

      Gamestate.new data
    end


    attr_reader :map

    private

    def initialize size, unexplored
      @map = []
      push_ocean size
      (size - 2).times do
        push_ocean 1
        unexplored ? push_unexplored(size - 2) : push_land(size - 2)
        push_ocean 1
      end
      push_ocean size
    end


    def push_ocean num
      num.times { @map << T_OCEAN * 4 + rand(4) }
    end


    def push_land num
      num.times { @map << rand(T_OCEAN * 4 - 4) + 4 }
    end


    def push_unexplored num
      num.times { @map << T_UNEXPLORED * 4 }
    end

  end
end
