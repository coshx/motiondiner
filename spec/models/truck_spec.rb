require 'spec_helper'

describe Truck do
  let(:truck) {FactoryGirl.build_stubbed(:truck)}
  
  describe "current_opening" do
    it "returns nil if the truck is not open" do
      truck.open = false
      truck.current_opening.should be_nil
    end
    it "gets the last location if the truck is open" do
      truck.should_receive(:last_opening)
      truck.open = true
      truck.current_opening
    end
  end

  describe "last_opening" do
    it "gets the last opening of the truck" do
      FactoryGirl.create(:opening, truck: truck, updated_at: DateTime.now - 2.days)
      last_opening = FactoryGirl.create(:opening, truck: truck, updated_at: DateTime.now - 1.day)
      FactoryGirl.create(:opening, truck: truck, updated_at: DateTime.now - 3.days)
      truck.last_opening.should == last_opening
    end
  end

  describe "open_at" do
    it "opens the truck" do
      truck.open_at(40.0150, 105.2700)
      truck.open?.should be_true
    end
    it "stores the opening of the truck" do
      truck.open_at(40.0150, 105.2700)
      truck.current_opening.lat.should == 40.015
      truck.current_opening.lng.should == 105.27
    end
  end

  describe "close!" do
    before :each do
      truck.open_at(40.0150, 105.2700)
    end
    it "closes the truck" do
      truck.close!
      truck.open?.should be_false
    end
    it "stores the time closed in the opening" do
      now = DateTime.parse('Jan 1, 2012')
      DateTime.stub!(:now) {now}
      truck.close!
      truck.last_opening.closed_at.should == now
    end
  end 
end
