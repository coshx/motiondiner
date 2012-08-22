require 'spec_helper'

describe TruckController do
  let(:truck) {FactoryGirl.build_stubbed(:truck)}
  
  describe "open" do
    it "opens the truck at the given location" do
      Truck.stub(:find) {truck}
      truck.should_receive(:open_at).with(40.015, 105.270)
      put :open, id: truck.id, lat: 40.015, lng: 105.270
      response.should be_successful
    end
  end

  describe "closed" do
    it "closes the truck" do
      Truck.stub(:find) {truck}
      truck.should_receive(:close!)
      put :close, id: truck.id
      response.should be_successful
    end
  end

end
