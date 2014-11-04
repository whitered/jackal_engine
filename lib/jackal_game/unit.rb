module JackalGame

  class Unit

    attr_accessor :location, :owner

    def initialize &block
      instance_eval &block if block_given?
    end

    def location val = nil
      @location = val unless val.nil?
      @location
    end

    def owner val = nil
      @owner = val unless val.nil?
      @owner
    end

  end

end
