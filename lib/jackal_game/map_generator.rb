module JackalGame

  class MapGenerator

    include JackalGame
    include TileConstants


    def self.generate options={}
      size = options[:size] || 13
      gen = MapGenerator.new size
      gen.map
    end


    attr_reader :map

    private

    def initialize size
      @map = []
      push_ocean size
      (size - 2).times do
        push_ocean 1
        push_land size - 2
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

  end
end
