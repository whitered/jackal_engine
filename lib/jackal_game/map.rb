module JackalGame

  class Map

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


  end

end
