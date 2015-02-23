module JackalGame

  class Tile

    T_UNEXPLORED = 0
    T_OCEAN = 46
    T_CROCODILE = 32


    attr_reader :type

    def initialize type
      @type = type
    end


    def explored?
      @type != T_UNEXPLORED
    end


    def accessible?
      ![T_OCEAN, T_CROCODILE].include? @type
    end


  end
end
