require 'test_helper'

class GameGeneratorTest < Minitest::Test

  include JackalGame
  include TileConstants


  def map
    @map ||= GameGenerator.map(size: 13)
  end


  def gamestate
    @gamestate ||= GameGenerator.gamestate(size: 13)
  end


  def test_map_generation
    assert_instance_of Array, map
    assert_equal 13 * 13, map.size
    assert_nil map.find { |elm| !elm.is_a?(Fixnum) or elm < 0 }
  end


  def test_tiles_rotation
    refute_nil map.find{ |t| Tile.new(t).rotation > 0 }, 'map should have some rotated tiles'
    refute_nil map.find{ |t| Tile.new(t).rotation == 0 }, 'map should have some unrotated tiles'
  end


  def test_ocean
    size = 13
    side = (0..size-1).to_a
    side.product(side).each do |x, y|
      t = Tile.new map[y * size + x]
      if x == 0 or x == size - 1 or y == 0 or y == size - 1
        assert_equal T_OCEAN, t.type, "ocean should be on #{x}, #{y}"
      else
        refute_equal T_OCEAN, t.type, "land should be on #{x}, #{y}"
      end
    end
  end


  def test_no_unexplored_tiles
    assert_nil map.find { |t| Tile.new(t).type == T_UNEXPLORED }, 'map should not have unexplored tiles'
  end


  def test_unexplored_generation
    map = GameGenerator.map(size: 7, unexplored: true)
    assert_equal 24, map.count { |t| Tile.new(t).type == T_OCEAN }
    assert_equal 25, map.count(T_UNEXPLORED)
  end


  def test_initial_map_size
    assert_equal 7, GameGenerator.gamestate( size: 7).map.size
    assert_equal 11, GameGenerator.gamestate( size: 11).map.size
  end


  def test_initial_unexplored
    map = GameGenerator.gamestate(size: 5).map
    [0, 4, 10, 19, 20, 24].each do |loc|
      assert_equal TileConstants::T_OCEAN, map.at(loc).type, "Tile at #{loc} should be ocean"
    end
    [6, 12, 13, 17].each do |loc|
      assert_equal TileConstants::T_UNEXPLORED, map.at(loc).type, "Tile at #{loc} should be unexplored"
    end
  end


  def test_initial_available_steps
    gamestate.start
    expected = {
      0 => { false => [7, 5] },
      1 => { false => [7, 20, 19, 18, 5] },
      2 => { false => [7, 20, 19, 18, 5] },
      3 => { false => [7, 20, 19, 18, 5] }
    }
    assert_equal expected, gamestate.available_steps
  end


end
