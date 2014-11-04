module JackalGame

  class Map

    attr_reader :map

    def initialize
      @map = (-121..-1).to_a
    end

    def shuffle seed
      @map.shuffle!
    end

    def to_json options={}
      { :map => @map }.to_json
    end

    def parse data
      @map = data[:map]
    end

  end

end
