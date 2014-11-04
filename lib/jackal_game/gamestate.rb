module JackalGame

  class GameState

    def self.initial
      GameState.new do
        p1 = player
        unit do
          location 115
          owner  p1
        end
        unit do
          location 100
          owner  p1
        end
      end
    end

    attr_reader :map, :players, :units

    def initialize &block
      @map = JackalGame::Map.new
      @players = []
      @units = []
      instance_eval &block if block_given?
    end

    def to_json(options={})
      { :map => @map, :units => @units }.to_json
    end

    def parse data
      @map = Map.new.parse data[:map]
    end

    def player &block
      p = Player.new &block
      @players << p
    end

    def unit &block
      @units << Unit.new(&block)
    end

  end

end
