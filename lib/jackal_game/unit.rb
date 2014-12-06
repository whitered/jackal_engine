module JackalGame

  class Unit


    def self.json_create data
      new data
    end


    attr_accessor :id


    def initialize data={}, &block
      @location = data['location']
      @id = data['id']
      instance_eval &block if block_given?
    end


    def as_json options={}
      {
        :json_class => self.class.name,
        :id => @id,
        :location => @location.as_json
      }
    end


    def location val = nil
      @location = val unless val.nil?
      @location
    end


  end

end
