module JackalGame

  class Unit


    def self.json_create data
      new data
    end


    attr_accessor :id, :location


    def initialize data={}
      @location = data['location']
      @id = data['id']
    end


    def as_json options={}
      {
        :json_class => self.class.name,
        :id => @id,
        :location => @location.as_json
      }
    end

  end

end
