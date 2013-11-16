class Event < ActiveRecord::Base
  has_many :resources, dependent: :destroy

  validates :name, presence: true
  validates :starts_at, presence: true
  validates :ends_at, presence: true

  def self.from_xml(xml)
    xml.collect do |event_element|
      event = Event.new({origin_ident: event_element['id']})
      event.name = event_element.at('./name').text
      event.starts_at = Time.parse(event_element.at('./start_datetime').text)
      event.ends_at = Time.parse(event_element.at('./end_datetime').text)
      # FIXME loop and use metaprogramming
      if subelement = event_element.at('./leader_notes')
        event.leader_notes = subelement.text
      end
      if subelement = event_element.at('./recurrence_description')
        event.recurrence_description = subelement.text
      end
      if subelement = event_element.at('./group')
        event.group = subelement.text
      end
      if subelement = event_element.at('./organizer')
        event.organizer = subelement.text
      end
      if subelement = event_element.at('./setup/start')
        event.setup_starts_at = Time.parse(subelement.text)
      end
      if subelement = event_element.at('./setup/end')
        event.setup_ends_at = Time.parse(subelement.text)
      end
      if subelement = event_element.at('./setup/notes')
        event.setup_notes = subelement.text
      end
      event.resources = Resource.from_xml(event_element.xpath('./resources/resource'))
      event
    end
  end
end