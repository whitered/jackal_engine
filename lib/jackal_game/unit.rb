module JackalGame

  class Unit


    def self.json_create data
      new data
    end


    attr_accessor :id, :location, :loot_id
    attr_reader :player_id, :type


    def initialize data={}
      @type = data['type']
      @location = data['location']
      @id = data['id']
      @player_id = data['player_id']
      @loot_id = data['loot_id']
    end


    def as_json options={}
      {
        :json_class => self.class.name,
        :id => @id,
        :type => @type,
        :player_id => @player_id,
        :location => @location.as_json,
        :loot_id => @loot_id
      }
    end


    def ship?
      @type == 'ship'
    end


    def pirate?
      @type == 'pirate'
    end

  end

end
