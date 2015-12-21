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


  def test_move_with_fake_loot
    initial_loc = @unit.location
    res = move 20, 6
    assert_equal initial_loc, @unit.location
    assert_equal "wrong step", res.first
    assert_equal 1, res.size
  end


  def test_move_updates_available_steps
    res = move 19
    expected_steps = {
      4 => { false => [163, 161] },
      5 => { false => [149, 150, 163, 161, 148] },
      6 => { false => [136, 137, 150, 163, 162, 161, 148, 135] },
      7 => { false => [122, 123, 136, 149, 148, 147, 134, 121] }
    }
    assert_equal expected_steps, res.first.available_steps
    assert_equal expected_steps, @gamestate.available_steps
  end


end
