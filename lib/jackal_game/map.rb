module JackalGame

  class Map

    TILE_OCEAN = JackalGame::Tile::T_OCEAN * 4


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
      Tile.new @tiles[location]
    end


    def open_tile location
      @tiles[location] = rand(45 * 4) + 1
    end


    def allowed_step from, to, last_location
      a = at from
      b = at to
      ay, ax = from.divmod @size
      by, bx = to.divmod @size
      move = [bx - ax, by - ay]
      prev_move = if last_location.present?
        ly, lx = last_location.divmod(@size)
        [ax - lx, ay - ly]
                  end
      allowed_moves = a.allowed_moves prev_move
      puts 'move', move.to_s, 'prev_move', prev_move.to_s, 'allowed_moves', allowed_moves.to_s
      allowed_moves.include? move
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
