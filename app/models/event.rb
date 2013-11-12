class Event < ActiveRecord::Base
  validates :name, presence: true
  validates :starts_at, presence: true
  validates :ends_at, presence: true

  def self.from_xml(xml)
    xml.collect do |event_element|
      event = Event.new({origin_ident: event_element['id']})
      event.name = event_element.at('./name').text
      event.leader_notes = event_element.at('./leader_notes').text
      event.starts_at = Time.parse(event_element.at('./start_datetime').text)
      event.ends_at = Time.parse(event_element.at('./end_datetime').text)
      event.recurrence_description = event_element.at('./recurrence_description').text
      event.group = event_element.at('./group').text
      event.organizer = event_element.at('./organizer').text
      event.setup_starts_at = Time.parse(event_element.at('./setup/start').text)
      event.setup_ends_at = Time.parse(event_element.at('./setup/end').text)
      event.setup_notes = event_element.at('./setup/notes').text
      event
    end
  end
end
