module JackalGame

  class Map

    include TileConstants


    def self.json_create data
      new data
    end


    attr_reader :size


    def initialize data={}
      @size = data['size'] || 13
      @tiles = data['tiles'] || ([0] * (@size * @size))
      @source = data['source']
    end


    def get_outermost_location location, direction
      x, y = get_tile_position location
      case direction
      when 0 then get_tile_id(x, 0)
      when 1 then get_tile_id(@size - 1, y)
      when 2 then get_tile_id(x, @size - 1)
      when 3 then get_tile_id(0, y)
      end
    end


    def as_json options={}
      {
        :json_class => self.class.name,
        :size => @size,
        :tiles => @tiles.as_json
      }
    end


    def get_tile_id x, y
      y * @size + x unless x < 0 or y < 0 or x >= @size or y >= @size
    end


    def get_tile_position location
      location.divmod(@size).reverse
    end


    def at location
      Tile.new @tiles[location]
    end


    def vector a, b
      ay, ax = a.divmod @size
      by, bx = b.divmod @size
      [bx - ax, by - ay]
    end


    def open_tile location
      @tiles[location] = @source[location]
    end


    def spawn player_id
      case player_id
      when 0 then get_tile_id(@size / 2, 0)
      when 1 then get_tile_id(@size / 2, @size - 1)
      when 2 then get_tile_id(@size - 1, @size / 2)
      when 3 then get_tile_id(0, @size / 2)
      end
    end




  end

end
