module JackalGame

  class GameState

    attr_reader :map

    def initialize &block
      @map = JackalGame::Map.new
      @players = []
      instance_eval &block if block_given?
    end

    def to_json(options={})
      { :map => @map }.to_json
    end

    def parse data
      @map = Map.new.parse data[:map]
    end

    def player &block
      p = Player.new &block
      @players << p
    end

  end

end
