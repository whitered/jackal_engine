module JackalGame

  class Player


    def self.json_create data
      new data
    end
    

    def initialize data={}, &block
      instance_eval &block if block_given?
    end



    def as_json options={}
      {
        :json_class => self.class.name
      }
    end

  end

end
