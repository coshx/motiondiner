require 'spec_helper'

describe TruckController do
  let(:truck) {FactoryGirl.build_stubbed(:truck)}

  context "truck exists" do
    before(:each) do
      Truck.stub(:find_by_id).with(truck.id.to_s) {truck}
    end
  
    describe "open" do
      it "opens the truck at the given location" do
        truck.should_receive(:open_at!).with(40.015, 105.270)
        put :open, id: truck.id, lat: 40.015, lng: 105.270
      end
    end

    describe "closed" do
      it "closes the truck" do
        truck.should_receive(:close!)
        put :close, id: truck.id
      end
    end

    describe "show" do
      it "renders json" do
        get :show, id: truck.id
        response.body.should == truck.to_json
      end
    end
  end

  context "no truck" do
    it "renders 404 for any request" do
      put :close, id: 12343254365
      response.should_not be_successful
    end
  end

end
