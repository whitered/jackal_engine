module JackalGame

  class Unit


    def self.json_create data
      new data
    end


    def initialize data={}, &block
      @location = data["location"]
      instance_eval &block if block_given?
    end


    def as_json options={}
      {
        :json_class => self.class.name,
        :location => @location.as_json
      }
    end


    def location val = nil
      @location = val unless val.nil?
      @location
    end


  end

end
