class Truck < ActiveRecord::Base
  attr_accessible :name, :open

  has_many :openings
  has_many :notifications

  def closed?
    !opened?
  end

  def current_opening
    return nil unless self.open?
    last_opening
  end

  def last_opening
    Opening.where(truck_id: self.id).order("updated_at DESC").limit(1).first
  end

  def open_at!(lat, lng)
    self.openings << Opening.create(lat: lat, lng: lng)
    self.open = true
    self.save!
  end

  def close!
    return nil unless self.open?
    opening = current_opening
    opening.closed_at = DateTime.now
    opening.save!
    self.open = false
    self.save!

    create_opening_notification
  end

  def create_opening_notification(date = Date.today)
    #return if date is within a week from today or there is already a future rapns_notifications waiting in queue
    return if date > Date.today + 1.week || Notification.has_queue_for_truck?(self.id)
    #find distrubution from past 2 month on day of week. A distrubution from the past week could also be a good idea...
    recent_openings = Opening.where(:truck_id => self.id).where("created_at > ?", DateTime.now - 2.months).select{|o| o.created_at.wday == date.wday}

    opening_distribution = Hash.new(0)
    recent_openings.each do |opening|
      similar_openings_count = recent_openings.select{|o| o.created_at.wday == opening.created_at.wday && o.created_at - o.created_at.beginning_of_day > (opening.created_at - 30.minutes) - opening.created_at.beginning_of_day && o.created_at - o.created_at.beginning_of_day < (opening.created_at + 30.minutes) - opening.created_at.beginning_of_day }.length
      recent_openings.select{|o| o.created_at.wday == opening.created_at.wday}
      opening_distribution[opening] = similar_openings_count
    end
    

    #weight distributions by date
    weighted_by_date = {}
    opening_distribution.each do |opening, num_occurences|
      weighted_by_date[opening] = num_occurences * (1 - (Date.today - opening.created_at.to_date)/124.0)
    end
    #get top distribution
    most_likely_opening = weighted_by_date.sort{|a,b| a[1] <=> b[1]}.last
    #if top distrubution value is high enough,schedule notification (give them 10 min extra to open via motion-diner)
    if most_likely_opening && most_likely_opening[1] > 0.8
      n = Notification.create(truck_id: self.id)
      self.notifications << n
      self.save!
      n.schedule_opening_notification(DateTime.parse(date.to_s + " " +(most_likely_opening[0].created_at + 10.minutes).strftime("%I:%M:%S%p").to_s))
    end
    #try schedule_opening_notifications for tomorrow
    create_opening_notification(date.tomorrow)
  end
  #handle_asynchronously :create_opening_notification

end
