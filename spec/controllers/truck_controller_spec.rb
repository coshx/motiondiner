require 'spec_helper'

describe TruckController do

  describe "open" do
    let(:truck) {FactoryGirl.create(:truck)}
    it "opens the truck at the given location" do
      put :open, id: truck.id, lat: "40.0150 N", long: "105.2700 W"
      now = DateTime.now
      DateTime.stub(:now) {now}
      truck.reload.open.should be_true
      truck.lat.should == "40.0150 N"
      truck.long.should == "105.2700 W"
    end
  end

end
