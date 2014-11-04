module JackalGame

  class Player

    def initialize &block
      instance_eval &block if block_given?
    end

  end

end
