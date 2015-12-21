module JackalGame

  class PathFinder

    include TileConstants

    NONE = 0
    TOP = 1
    TR = 2
    RIGHT = 4
    BR = 8
    BOTTOM = 16
    BL = 32
    LEFT = 64
    TL = 128

    DIRECTIONS = [
      [0, -1],
      [1, -1],
      [1, 0],
      [1, 1],
      [0, 1],
      [-1, 1],
      [-1, 0],
      [-1, -1]
    ]






    def initialize gamestate
      @gamestate = gamestate
      @map = gamestate.map
      @banned = {}
    end
    

    def find_next_steps unit, prev_location, location, carried_loot
      tile = @map.at(location)
      steps = case tile.type
      when JackalGame::Tile::T_SLIDE_PARACHUTE
        ship = @gamestate.units.find { |u| u and u.ship? and u.player_id == @unit.player_id }
        [ship.location]
      when JackalGame::Tile::T_SLIDE_GUN
        [@map.get_outermost_location(location, tile.rotation)]
      else
        x, y = @map.get_tile_position location
        vector = prev_location && @map.vector(prev_location, location)
        available_moves = available_moves(tile, vector)
        steps = available_moves.map { |m| @map.get_tile_id(x + m.first, y + m.last) }.compact
        steps.delete_if { |s| !tile_accessible?(@map.at(s).type, unit.ship?, carried_loot) }
        steps
      end

      ban = @banned[location] || []

      steps - ban
    end


    def ban from, to
      (@banned[from] ||= []) << to
    end


    def tile_accessible? tile_type, byShip, withLoot
      if byShip
        tile_type == T_OCEAN
      else
        return false if [T_CROCODILE].include? tile_type
        return false if withLoot and !explored?
        return false if withLoot and SHELTERS.include? tile_type
        true
      end
    end



    def available_moves tile, prev_move
      type = tile.type
      return [prev_move] if type == T_SLIDE_FWD

      if type == T_SLIDE_HORSE
        c = [-1, 1].product [-2, 2]
        return c + c.map(&:reverse)
      end


      unrotated_directions = case type
      when T_SLIDE_1 then TOP
      when T_SLIDE_1T then TR
      when T_SLIDE_2 then TOP | BOTTOM
      when T_SLIDE_2T then TR | BL
      when T_SLIDE_4 then TOP | RIGHT | BOTTOM | LEFT
      when T_SLIDE_4T then TR | BR | BL | TL
      when T_SLIDE_3 then TR | BOTTOM | LEFT
      else TOP | TR | RIGHT | BR | BOTTOM | BL | LEFT | TL
      end
      
      shift = tile.rotation * 2
      rotated_directions = (unrotated_directions << shift | unrotated_directions >> 8 - shift) & 255

      moves = []
      (0..7).each do |sh|
        moves << DIRECTIONS[sh] if 1 << sh & rotated_directions > 0
      end
      moves
    end


  end
end
