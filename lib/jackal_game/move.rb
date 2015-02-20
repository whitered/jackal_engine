module JackalGame

  class Move


    attr_reader :unit, :location
    attr_accessor :tile, :current_move_player_id


    def initialize params
      @current_move_player_id = params[:current_move_player_id]
      @action = params[:action]
      @unit = params[:unit].to_i
      @location = params[:location].to_i
    end
  end
end
