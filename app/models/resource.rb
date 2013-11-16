class Resource < ActiveRecord::Base
  belongs_to :event
  attr_accessor :status

  validates :event_id, presence: true
  validates :name, presence: true

  def self.from_xml(xml)
    xml.collect do |resource_element|
      resource = Resource.new
      resource.name = resource_element.at('./name').text
      if status_element = resource_element.at('./status')
        resource.status = status_element.text
      end
      resource
    end
  end
end
