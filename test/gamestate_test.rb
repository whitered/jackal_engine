require 'test_helper'

class GamestateTest < Minitest::Test

  include JackalGame

  def setup

  end


  def test_initial_map_size
    assert_equal 7, GameState.initial( size: 7).map.size
    assert_equal 11, GameState.initial( size: 11).map.size
  end


  def test_initial_unexplored
    map = GameState.initial(size: 5).map
    [0, 4, 10, 19, 20, 24].each do |loc|
      assert_equal TileConstants::T_OCEAN, map.at(loc).type, "Tile at #{loc} should be ocean"
    end
    [6, 12, 13, 17].each do |loc|
      assert_equal TileConstants::T_UNEXPLORED, map.at(loc).type, "Tile at #{loc} should be unexplored"
    end
  end


  def test_move_to_unexplored_opens_tile_from_source
    gamestate = GameState.initial(size: 5)
    gamestate.start
    gamestate.source_map = [32, 36, 40, 44, 48] * 5
    action = Action.new({
      'current_move_player_id' => gamestate.current_move_player_id,
      'action' => 'move',
      'unit' => gamestate.units[1].id,
      'location' => 7
    })

    unexplored_tile = TileConstants::T_UNEXPLORED
    expected_tile = gamestate.source_map[action.location]

    refute_equal expected_tile, unexplored_tile
    assert_equal TileConstants::T_UNEXPLORED, gamestate.map.at(action.location).type
    res = gamestate.move action
    assert_equal expected_tile, gamestate.map.at(action.location).value
  end

end
