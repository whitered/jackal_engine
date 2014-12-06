module JackalGame

  class Move


    attr_reader :unit, :location


    def initialize params
      @action = params[:action]
      @unit = params[:unit].to_i
      @location = params[:location].to_i
    end
  end
end
