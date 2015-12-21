module JackalGame

  class Tile

    include TileConstants

    attr_reader :value

    def initialize value
      @value = value
    end


    def type
      value / 4
    end


    def rotation
      value % 4
    end
    

    def explored?
      type != T_UNEXPLORED
    end


    def get_loot
      case type
      when T_ROME_1 then Array.new(1) { Loot.new('type' => 'rome') }
      when T_ROME_2 then Array.new(2) { Loot.new('type' => 'rome') }
      when T_ROME_3 then Array.new(3) { Loot.new('type' => 'rome') }
      when T_COIN_1 then Array.new(1) { Loot.new('type' => 'coin') }
      when T_COIN_2 then Array.new(2) { Loot.new('type' => 'coin') }
      when T_COIN_3 then Array.new(3) { Loot.new('type' => 'coin') }
      when T_COIN_4 then Array.new(4) { Loot.new('type' => 'coin') }
      when T_COIN_5 then Array.new(5) { Loot.new('type' => 'coin') }
      when T_CHEST then [ Loot.new('type' => 'chest') ]
      end
    end


    def transit?
      TRANSIT.include? type
    end


  end
end
