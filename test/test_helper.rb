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


  def equals value
    -> (v) { v == value }
  end


  def validate_hash hash, validations
    validation = HashValidator.validate(hash, validations)
    assert validation.valid?, "Invalid hash: " + validation.errors.to_s
  end
