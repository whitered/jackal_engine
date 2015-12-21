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


  def test_available_steps
    steps = {
      0 => { false => [7, 5] },
      1 => { false => [20, 21, 34, 47, 46, 45, 32, 19] },
      2 => {
        false => [6, 7, 20, 33, 32, 31, 5],
        true => [6, 7, 20, 33, 32, 5]
      },
      3 => { false => [37, 38, 51, 64, 63, 62, 49, 36] }
    }
    assert_equal steps, @path_finder.get_available_steps(0)
  end


end
