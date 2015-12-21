require 'test_helper'

class PathFinderTest < Minitest::Test

  include JackalGame

  def setup
    load_gamestate
    @path_finder = PathFinder.new @gamestate
  end


  def test_next_steps
    unit = @gamestate.get_unit 1
    steps = @path_finder.find_next_steps unit, nil, unit.location, nil
    assert_equal [20, 21, 34, 47, 46, 45, 32, 19], steps
  end


end
