require 'test_helper'

class MapGeneratorTest < Minitest::Test

  include JackalGame
  include TileConstants


  def setup
    @size = 13
    @map = MapGenerator.generate(size: @size)
  end


  def test_map_generation
    assert_instance_of Array, @map
    assert_equal @size * @size, @map.size
    assert_nil @map.find { |elm| !elm.is_a?(Fixnum) or elm < 0 }
  end


  def test_tiles_rotation
    refute_nil @map.find{ |t| Tile.new(t).rotation > 0 }, 'map should have some rotated tiles'
    refute_nil @map.find{ |t| Tile.new(t).rotation == 0 }, 'map should have some unrotated tiles'
  end


  def test_ocean
    side = (0..@size-1).to_a
    side.product(side).each do |x, y|
      t = Tile.new @map[y * @size + x]
      if x == 0 or x == @size - 1 or y == 0 or y == @size - 1
        assert_equal T_OCEAN, t.type, "ocean should be on #{x}, #{y}"
      else
        refute_equal T_OCEAN, t.type, "land should be on #{x}, #{y}"
      end
    end
  end


  def test_no_unexplored_tiles
    assert_nil @map.find { |t| Tile.new(t).type == T_UNEXPLORED }, 'map should not have unexplored tiles'
  end
end
