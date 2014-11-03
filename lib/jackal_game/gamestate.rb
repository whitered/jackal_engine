module JackalGame

  class GameState

    attr_reader :map

    def initialize
      @map = JackalGame::Map.new
    end

    def to_json(options={})
      { :map => @map }.to_json
    end

    def parse data
      @map = Map.new.parse data[:map]
    end

  end

end
