module JackalGame

  class Player


    def self.json_create data
      new data
    end


    attr_accessor :id
    

    def initialize data={}
      @id = data['id']
    end



    def as_json options={}
      {
        :json_class => self.class.name,
        :id => @id
      }
    end

  end

end
