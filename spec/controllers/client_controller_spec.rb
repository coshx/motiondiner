require 'spec_helper'

describe ClientController do
  describe "GET near_by_trucks" do
    context "no location" do
      it "doesn't render sucessfully" do
        get :near_by_trucks
        response.should_not be_sucessful
        response.body.should == "Location needed to find near by trucks. Please enable GPS.".to_json
      end
    end
    context "no miles given" do
      it "should use 5 miles for a default" do
        opening = FactoryGirl.build(:opening)
        Opening.should_receive(:within).with(5, {:origin=>["40.015", "105.27"]}).and_return {opening}
        get :near_by_trucks, lat: 40.015, lng: 105.270
        response.should be_sucessful
        response.body.should == [opening.truck].to_json 
      end
    end
    context "finding a truck" do
      let(:truck) {FactoryGirl.create(:truck)}
      it "gets trucks within the given radius" do
        truck.open_at(40.015, 105.27)
        get :near_by_trucks, lat: 40.014, lng: 105.271, radius: 1
        response.body.should == [truck].to_json
      end
      it "doesn't find trucks outside the given radius" do
        truck.open_at(38, 104)
        get :near_by_trucks, lat: 40.014, lng: 105.271, radius: 1
        response.body.should == "No trucks found".to_json
      end
      it "doesn't find closed trucks" do
        Truck.any_instance.stub(:create_opening_notification) {true}
        truck.open_at(40.015, 105.27)
        truck.close!
        get :near_by_trucks, lat: 40.014, lng: 105.271, radius: 1
        response.body.should == "No trucks found".to_json
      end
    end
  end
end