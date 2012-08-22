class Opening < ActiveRecord::Base
  attr_accessible :lat, :lng
  acts_as_mappable
  belongs_to :truck
end