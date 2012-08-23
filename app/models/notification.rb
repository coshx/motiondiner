class Notification < ActiveRecord::Base
  attr_accessible :truck_id

  belongs_to :truck

  def self.has_queue_for_truck?(truck_id)
    Notification.where(truck_id: truck_id).where("scheduled_for > ?", DateTime.now).present?
  end

  def schedule_opening_notification(scheduled_for)
    self.scheduled_for = scheduled_for
    self.save!
  end

protected
  def send_opening_notification
    if truck.closed?
      n = Rapns::Notification.new
      n.app = "motion-diner"
      n.device_token = self.device_token
      n.alert = "This is the message shown on the device."
      n.badge = 1
      n.sound = "1.aiff"
      n.expiry = 30.minutes.to_i
      #n.attributes_for_device = {"question" => nil, "answer" => 42}
      n.deliver_after = 1.minute.from_now
      begin
        n.save!
      rescue Exception => e
        logger.error "\n Failed to send notification:\n"
        logger.error e.inspect
        logger.error n.inspect
      end
    end
    schedule_next_truck_notification
  end
  handle_asynchronously :send_opening_notification, :run_at => Proc.new { self.scheduled_for } 

  def schedule_next_truck_notification
    truck.create_opening_notification
  end
  handle_asynchronously :schedule_next_truck_notification, :run_at => Proc.new { 2.hours.from_now }
end
