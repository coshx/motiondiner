class ClientController < ApplicationController

  def near_by_trucks
    unless params[:lat].present? && params[:lng].present?
      render :json => "Location needed to find near by trucks. Please enable GPS.".to_json, :status => 404
      return
    end
    distance = params[:radius] || 5 
    nearby_trucks = Array(Opening.where(closed_at: nil).within(distance, :origin => [params[:lat], params[:lng]])).map(&:truck).uniq
    nearby_trucks = "No trucks found" if nearby_trucks.blank?
    render json: nearby_trucks.to_json
  end

end
