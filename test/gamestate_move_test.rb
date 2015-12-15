require 'test_helper'


class GamestateMoveTest < Minitest::Test

  include JackalGame

  def setup
    source = [184,187,186,185,185,184,184,184,184,184,184,184,184,184,32,176,32,32,128,176,48,73,32,176,128,184,185,32,66,68,32,68,88,32,32,92,32,32,184,185,32,128,128,33,128,75,48,72,128,128,33,184,184,32,32,32,33,32,32,32,32,32,32,32,184,184,32,33,33,33,32,32,33,33,33,32,32,184,186,32,32,33,32,32,32,32,32,33,32,32,184,186,32,33,32,32,33,33,33,33,32,32,33,184,185,32,33,32,33,33,32,32,33,32,32,32,184,185,32,32,32,33,32,34,35,33,32,32,32,184,185,33,32,33,34,33,34,32,33,33,33,32,184,184,33,33,32,32,32,32,32,32,32,32,33,184,186,186,185,184,185,186,184,184,184,184,184,184,184]
    @gamestate = GameState.initial(num_of_players: 2, size: 13)
    gamestate.source_map = source
    gamestate.start
    @unit = @gamestate.units[1]
  end


  def loc x, y
    @gamestate.map.get_tile_id x, y
  end


  def start_from x, y
    @unit.location = loc x, y
  end


  def move x, y, loot=nil
    params = {
      'current_move_player_id' => @gamestate.players.first.id,
      'action' => 'move',
      'unit' => @unit.id,
      'location' => loc(x, y),
      'carried_loot' => loot
    }
    action = Action.new params
    @gamestate.move action
  end



  def test_simple_move
    start_from 1, 1
    res = move 1, 2
    
    assert_equal loc(1, 2), @unit.location
    assert_equal loc(1, 2), res.first.location
  end


end
