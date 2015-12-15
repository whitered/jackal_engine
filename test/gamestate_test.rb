require 'test_helper'

class GamestateTest < Minitest::Test

  include JackalGame

  def setup

  end


  def test_initial_map_size
    assert_equal 7, GameState.initial( size: 7).map.size
    assert_equal 11, GameState.initial( size: 11).map.size
  end

end
