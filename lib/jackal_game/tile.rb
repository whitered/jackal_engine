module JackalGame

  class Tile

    NONE = 0
    TOP = 1
    TR = 2
    RIGHT = 4
    BR = 8
    BOTTOM = 16
    BL = 32
    LEFT = 64
    TL = 128

    DIRECTIONS = [
      [0, -1],
      [1, -1],
      [1, 0],
      [1, 1],
      [0, 1],
      [-1, 1],
      [-1, 0],
      [-1, -1]
    ]




    T_UNEXPLORED = 0
    T_ROME_1 = 24
    T_ROME_2 = 25
    T_ROME_3 = 26
    T_CROCODILE = 32
    T_COIN_1 = 40
    T_COIN_2 = 41
    T_COIN_3 = 42
    T_COIN_4 = 43
    T_COIN_5 = 44
    T_CHEST = 45
    T_OCEAN = 46

    T_SLIDE_HORSE = 12
    T_SLIDE_1 = 16
    T_SLIDE_2 = 17
    T_SLIDE_1T = 18
    T_SLIDE_2T = 19
    T_SLIDE_4 = 20
    T_SLIDE_4T = 21
    T_SLIDE_3 = 22
    T_SLIDE_FWD = 23
    

    TRANSIT = [T_SLIDE_HORSE, T_SLIDE_1, T_SLIDE_2, T_SLIDE_1T, T_SLIDE_2T, T_SLIDE_4, T_SLIDE_4T, T_SLIDE_3, T_SLIDE_FWD]


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


    def accessible? unit, loot
      if unit.pirate?
        return false if [T_OCEAN, T_CROCODILE].include? type
        return false if loot and !explored?
        true
      elsif unit.ship?
        type == T_OCEAN
      end
    end



    def available_moves prev_move
      return [prev_move] if type == T_SLIDE_FWD

      if type == T_SLIDE_HORSE
        c = [-1, 1].product [-2, 2]
        return c + c.map(&:reverse)
      end


      unrotated_directions = case type
      when T_SLIDE_1 then TOP
      when T_SLIDE_1T then TR
      when T_SLIDE_2 then TOP | BOTTOM
      when T_SLIDE_2T then TR | BL
      when T_SLIDE_4 then TOP | RIGHT | BOTTOM | LEFT
      when T_SLIDE_4T then TR | BR | BL | TL
      when T_SLIDE_3 then TR | BOTTOM | LEFT
      else TOP | TR | RIGHT | BR | BOTTOM | BL | LEFT | TL
      end
      
      shift = rotation * 2
      rotated_directions = (unrotated_directions << shift | unrotated_directions >> 8 - shift) & 255

      moves = []
      (0..7).each do |sh|
        moves << DIRECTIONS[sh] if 1 << sh & rotated_directions > 0
      end
      moves
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
