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

  describe "open_at!" do
    it "opens the truck" do
      truck.open_at!(40.0150, 105.2700)
      truck.open?.should be_true
    end
    it "stores the opening of the truck" do
      truck.open_at!(40.0150, 105.2700)
      truck.current_opening.lat.should == 40.015
      truck.current_opening.lng.should == 105.27
    end
  end

  describe "close!" do
    before :each do
      truck.open_at!(40.0150, 105.2700)
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

  describe "create_opening_notification" do
    let(:notification_delay) {10.minutes}
    before :each do
      Timecop.freeze(DateTime.parse("Thu, 23 Aug 2012 13:00:00"))
      #Opening.any_instance.stub(:truck) {truck}
    end
    it "can schedule a notification for the same day" do
      FactoryGirl.create(:opening, truck: truck, created_at: DateTime.now - 1.week + 1.hour)
      FactoryGirl.create(:opening, truck: truck, created_at: DateTime.now - 2.weeks + 1.hour)
      truck.create_opening_notification
      Notification.last.scheduled_for.should == DateTime.now + 1.hour + notification_delay
    end
    it "can schedule a notification for the next day" do
      FactoryGirl.create(:opening, truck: truck, created_at: DateTime.now + 1.day - 1.week + 1.hour)
      FactoryGirl.create(:opening, truck: truck, created_at: DateTime.now + 1.day - 2.weeks + 1.hour)
      truck.create_opening_notification
      Notification.last.scheduled_for.should == DateTime.now + 1.day + 1.hour + notification_delay
    end
    it "schedules the more frequent distribution" do
      FactoryGirl.create(:opening, truck: truck, created_at: DateTime.now + 2.days - 1.week + 1.hour)
      FactoryGirl.create(:opening, truck: truck, created_at: DateTime.now + 2.days - 2.weeks + 2.hours)
      FactoryGirl.create(:opening, truck: truck, created_at: DateTime.now + 2.days - 3.weeks + 2.hours)
      truck.create_opening_notification
      Notification.last.scheduled_for.should == DateTime.now + 2.days + 2.hour + notification_delay
    end
    after :each do
      Timecop.return #release freeze
    end
  end
end
