class Resource < ActiveRecord::Base
  belongs_to :event
  validates :event_id, presence: true
  validates :name, presence: true
end
