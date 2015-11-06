module JackalGame

  class Loot


    def self.json_create data
      new data
    end


    attr_accessor :id, :location
    attr_reader :type

    def initialize data={}
      @type = data['type']
      @id = data['id']
      @location = data['location']
    end



    def as_json options={}
      {
        :json_class => self.class.name,
        :id => @id,
        :type => @type,
        :location => @location.as_json
      }
    end

  end
end
