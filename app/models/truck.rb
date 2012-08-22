class Truck < ActiveRecord::Base
  attr_accessible :name, :open

  has_many :openings

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
  end
end
