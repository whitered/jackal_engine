class TestMap < Minitest::Test
  
  include JackalGame
  include TileConstants

  def setup
    
    size = 7
    @source = [
      T_OCEAN, T_OCEAN + 2, T_OCEAN + 2, T_OCEAN + 2, T_OCEAN + 2, T_OCEAN + 2, T_OCEAN + 2
    ]

    tiles = [T_UNEXPLORED] * size * size


    @map = Map.new({'size' => 7, 'tiles' => tiles, 'source' => @source})
  end



  def test_map_take_tiles_from_source
    x = 5
    assert_equal T_UNEXPLORED, @map.at(x).type
    refute_equal T_UNEXPLORED, @source[x]
    @map.open_tile x
    assert_equal @source[x], @map.at(x).value
  end

end
