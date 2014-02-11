class EventException
  def self.from_xml(xml, time)
    xml.collect do |exception_element|
      Time.parse("#{exception_element.at('./date').text} #{time}").strftime("%Y-%m-%dT%H:%M:%S")
    end.join('|')
  end
end
