require 'test_helper'


class GamestateMoveTest < Minitest::Test

  include JackalGame

  def setup
    @gamestate = load_gamestate
    @gamestate.start
    @unit = @gamestate.units[1]
  end


  def loc x, y
    @gamestate.map.get_tile_id x, y
  end


  def move loc, loot=nil
    params = {
      'current_move_player_id' => @gamestate.players.first.id,
      'action' => 'move',
      'unit' => @unit.id,
      'location' => loc,
      'carried_loot' => loot
    }
    action = Action.new params
    @gamestate.move action
  end



  def test_simple_move
    res = move 32
    
    assert_equal 32, @unit.location
    assert_equal 32, res.first.location
  end


  def test_move_fails_for_nonavailable_step
    initial_loc = @unit.location
    res = move 59
    assert_equal initial_loc, @unit.location
    assert_equal "wrong step", res.first
    assert_equal 1, res.size
  end


end
