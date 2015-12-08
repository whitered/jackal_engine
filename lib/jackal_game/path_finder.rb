module JackalGame
  class PathFinder

    def initialize gamestate, unit
      @gamestate = gamestate
      @map = gamestate.map
      @unit = unit
      @banned = {}
    end
    

    def find_next_steps prev_location, location, carried_loot
      tile = @map.at(location)
      steps = case tile.type
      when JackalGame::Tile::T_SLIDE_PARACHUTE
        ship = @gamestate.units.find { |u| u and u.ship? and u.player_id == @unit.player_id }
        [ship.location]
      when JackalGame::Tile::T_SLIDE_GUN
        [@map.get_outermost_location(location, tile.rotation)]
      else
        x, y = @map.get_tile_position location
        available_moves = tile.available_moves(@map.vector(prev_location, location))
        steps = available_moves.map { |m| @map.get_tile_id(x + m.first, y + m.last) }.compact
        steps.delete_if { |s| !@map.at(s).accessible?(@unit, carried_loot) }
        steps
      end

      ban = @banned[location] || []

      steps - ban
    end


    def ban from, to
      (@banned[from] ||= []) << to
    end
  end
end
