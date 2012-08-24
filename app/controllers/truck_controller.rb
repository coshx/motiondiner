class TruckController < ApplicationController

  before_filter :load_truck, :only => [:open, :close, :show, :update, :destroy]

  #restful actions
  def create
    @truck = Truck.new(params[:truck])

    respond_to do |format|
      if @truck.save
        format.json { render json: @truck, status: :created, location: @truck }
      else
        format.json { render json: @truck.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @truck.update_attributes(params[:truck])
        format.json { head :no_content }
      else
        format.json { render json: @truck.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @truck.destroy

    respond_to do |format|
      format.json { head :no_content }
    end
  end

  def show
    render :json => @truck.to_json
  end

  #non-restful actions
  def open
    @truck.open_at(params[:lat].to_f, params[:lng].to_f)
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  def close
    @truck.close!
    respond_to do |format|
      format.json { head :no_content }
    end
  end


  protected

  def load_truck
    @truck = Truck.find_by_id(params[:id])
    render :json => "Truck Not found".to_json, :status => 404 unless @truck.present?
  end


end
