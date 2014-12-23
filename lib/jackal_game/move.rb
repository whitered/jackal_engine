module JackalGame

  class Move


    attr_reader :unit, :location, :current_player
    attr_accessor :tile


    def initialize params
      @current_player = params[:current_player]
      @action = params[:action]
      @unit = params[:unit].to_i
      @location = params[:location].to_i
    end
  end
end
