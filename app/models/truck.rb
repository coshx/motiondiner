class Truck < ActiveRecord::Base
  attr_accessible :name, :open

  has_many :openings
  has_many :rapns_notifications

  def current_opening
    return nil unless self.open?
    last_opening
  end

  def last_opening
    Opening.where(truck_id: self.id).order("updated_at DESC").limit(1).first
  end

  def open_at(lat, lng)
    self.openings << Opening.create(lat: lat, lng: lng)
    self.open =true
    self.save!
  end

  def close!
    return nil unless self.open?
    opening = current_opening
    opening.closed_at = DateTime.now
    opening.save!
    self.open = false
    self.save!

    schedule_opening_notifications(Date.today) #delay_job canidate
  end

  def schedule_opening_notifications(date)
    #return if date is within a week from today or there is already a future rapns_notifications waiting in queue
    return if date + 1.week + 1.day > Date.today || (self.rapns_notifications.select {|n| n.deliver_after > DateTime.now}).present?
    #find distrubution from past 2 month on day of week
    recent_openings = Opening.where(:truck_id => self.id).where("created_at > ?", DateTime.now - 2.monthes).select{|o| o.created_at.wday == date.wday}
    recent_openings = recent_openings.distrubution_hash
    #weight distributions by date
    weighted_by_date = {}
    recent_openings.each do |opening, num_occurences|
      weighted_by_date[opening] = num_occurences * (1 - (Date.today - o.created_at.to_date)/124.0)
    end
    #get top distribution
    most_likely_opening = weighted_by_date.sort{|a,b| a[1] <=> b[1]}.last
    #if top distrubution value is high enough,schedule notification
    if most_likely_opening[1] > 0.8
    #schedule_opening_notifications for tomorrow
    schedule_opening_notifications(date.tomorrow)
  end
end
