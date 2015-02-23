module JackalGame

  class Unit


    def self.json_create data
      new data
    end


    attr_accessor :id, :location
    attr_reader :player_id


    def initialize data={}
      @location = data['location']
      @id = data['id']
      @player_id = data['player_id']
    end


    def as_json options={}
      {
        :json_class => self.class.name,
        :id => @id,
        :player_id => @player_id,
        :location => @location.as_json
      }
    end

  end

end
