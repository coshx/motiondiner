class TruckController < ApplicationController

  before_filter :load_truck, :only => [:open, :close]


  #restful actions


  #non-restful actions
  def open
    @truck.open_at(params[:lat].to_f, params[:lng].to_f)
    render nothing: true
  end

  def close
    @truck.close!
    render nothing: true
  end


  protected

  def load_truck
    @truck = Truck.find(params[:id])
  end


end
