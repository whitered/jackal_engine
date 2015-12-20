require 'jackal_game'
require 'minitest/autorun'
require 'minitest/pride'
require 'minitest/osx'
require 'json'


  def load_gamestate
    json = File.read 'test/data/gamestate.json'
    @gamestate = JSON.load(json)
    @gamestate.source_map = JSON.load(File.read 'test/data/map.json')
    @gamestate
  end


  def assert_includes_hash a, b
    key = get_hash_difference a, b
    assert_nil key, "Value of [#{key}] should be same"
  end


  def refute_includes_hash a, b
    key = get_hash_difference a, b
    refute_nil key, "Values should not be the same"
  end


  def get_hash_difference a, b
    b.each_pair do |k, v|
      if a.respond_to?(k)
        l = a.send(k)
      elsif a.is_a?(Hash)
        l = a[k]
      else
        return k
      end
      if v.is_a?(Hash)
        return k unless get_hash_difference(l, v).nil?
      else
        return k unless l == v
      end
    end
    nil
  end


