require 'test_helper'

class ActionTest < Minitest::Test


  include JackalGame


  def setup
    @action = Action.new(unit: 3, location: 4)
  end



  def test_predict_death
    @action.available_steps = {}
    predict = @action.predict_next_action
    refute_nil predict
    assert_equal 'death', predict.action
    assert_equal @action.unit, predict.unit
  end


  def test_predict_only_move
    @action.available_steps = { 3 => { false => [5] }}
    predict = @action.predict_next_action
    refute_nil predict
    assert_equal 3, predict.unit
    assert_equal 5, predict.location
  end


  def test_predict_multiple_steps
    @action.available_steps = { 3 => { false => [5, 6] }}
    predict = @action.predict_next_action
    assert_nil predict
  end


  def test_predict_multiple_units
    @action.available_steps = { 3 => { false => [2] }, 4 => { true => [5] } }
    predict = @action.predict_next_action
    assert_nil predict
  end


  def test_predict_no_available_steps
    @action.available_steps = nil
    predict = @action.predict_next_action
    assert_nil predict
  end

end
