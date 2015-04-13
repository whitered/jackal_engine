module JackalGame

  class Loot


    def self.json_create data
      new data
    end


    attr_accessor :location
    attr_reader :type

    def initialize data={}
      @type = data['type']
      @location = data['location']
    end



    def as_json options={}
      {
        :json_class => self.class.name,
        :type => @type,
        :location => @location.as_json
      }
    end

  end
end
