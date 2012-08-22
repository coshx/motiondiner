class TruckController < ApplicationController

  before_filter :load_truck, :only => [:open]


  #restful actions


  #non-restful actions
  def open
    @truck.open = true
    @truck.lat = params[:lat]
    @truck.long = params[:long]
    @truck.opened_at = DateTime.now
    @truck.save!
    render nothing: true
  end


  protected

  def load_truck
    @truck = Truck.find(params[:id])
  end


end
