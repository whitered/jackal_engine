module JackalGame

  class Map

    attr_reader :map

    def initialize
      @map = [0] * 81
    end

    def to_json options={}
      { :map => @map }.to_json
    end

    def parse data
      @map = data[:map]
    end

  end

end
