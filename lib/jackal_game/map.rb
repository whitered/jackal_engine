module JackalGame

  class Map

    TILE_OCEAN = 46


    def self.generate options={}
      size = options['size'] || 13
      tiles = []
      tiles.concat [TILE_OCEAN] * size
      (size - 2).times do
        tiles << TILE_OCEAN
        tiles.concat [0] * (size - 2)
        tiles << TILE_OCEAN
      end
      tiles.concat [TILE_OCEAN] * size
      Map.new 'size' => size, 'tiles' => tiles
    end


    def self.json_create data
      new data
    end


    def initialize data={}
      @size = data['size'] || 13
      @tiles = data['tiles'] || ([0] * (@size * @size))
    end


    def as_json options={}
      {
        :json_class => self.class.name,
        :size => @size,
        :tiles => @tiles.as_json
      }
    end


    def get_tile_id x, y
      y * @size + x
    end


    def at location
      @tiles[location]
    end


    def open_tile location
      @tiles[location] = rand(45) + 1
    end


    def tiles_close a, b
      return false if a==b
      ax, ay = a.divmod @size
      bx, by = b.divmod @size
      (ax - bx).abs <= 1 && (ay - by).abs <= 1
    end


  end

end
