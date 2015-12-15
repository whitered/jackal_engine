require 'test_helper'

class MapTest < Minitest::Test
  
  include JackalGame
  include TileConstants

  def setup
    size = 7
    tiles = [T_UNEXPLORED] * size * size

    @map = Map.new({'size' => size, 'tiles' => tiles})
  end



  def test_map_take_tiles_from_source
    loc = 5
    src = 32
    assert_equal T_UNEXPLORED, @map.at(loc).type
    refute_equal T_UNEXPLORED, src
    @map.set_tile loc, src
    assert_equal src, @map.at(loc).value
  end

end
