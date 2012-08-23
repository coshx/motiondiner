require 'spec_helper'

describe Notification do
  let(:notification) {FactoryGirl.build(:notification)}
  describe "has_queue_for_truck?" do
    context "has notification in queue" do
      it "returns true" do
        notification.scheduled_for = DateTime.tomorrow
        notification.save!
        Notification.has_queue_for_truck?(notification.truck_id).should be_true
      end
    end

    context "doesnt have notification in queue" do
      it "returns false" do
        notification.scheduled_for = DateTime.yesterday
        notification.save!
        Notification.has_queue_for_truck?(notification.truck_id).should be_false
      end
    end
    
  end
end
