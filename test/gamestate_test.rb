require 'test_helper'

class GamestateTest < Minitest::Test

  include JackalGame

  def setup
    @gamestate = load_gamestate
  end


  def test_get_unit
    assert_equal 2, @gamestate.get_unit(2).id
  end


  def test_move_to_unexplored_opens_tile_from_source
    @gamestate.start
    action = Action.new({
      'current_move_player_id' => @gamestate.current_move_player_id,
      'action' => 'move',
      'unit' => @gamestate.units[1].id,
      'location' => 34
    })

    unexplored_tile = TileConstants::T_UNEXPLORED
    expected_tile = @gamestate.source_map[action.location]

    refute_equal expected_tile, unexplored_tile
    assert_equal TileConstants::T_UNEXPLORED, @gamestate.map.at(action.location).type
    res = @gamestate.move action
    assert_equal expected_tile, @gamestate.map.at(action.location).value
  end


end
