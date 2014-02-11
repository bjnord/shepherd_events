include ActionDispatch::TestProcess

f = fixture_file_upload('spec/fixtures/mixed_approvals.xml', 'text/xml')
xml = Nokogiri::XML(f).xpath("//events/event")
@events = Event.from_xml(xml).select {|e| e.setupable? }
@events.each {|e| e.save! }

f = fixture_file_upload('spec/fixtures/with_exceptions.xml', 'text/xml')
xml = Nokogiri::XML(f).xpath("//events/event")
@events = Event.from_xml(xml).select {|e| e.setupable? }
@events.each {|e| e.save! }
