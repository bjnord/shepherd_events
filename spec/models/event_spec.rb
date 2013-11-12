require 'spec_helper'
require 'nokogiri'

describe Event do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:starts_at) }
  it { should validate_presence_of(:ends_at) }

  describe '#from_xml' do
    let(:xml) do
      extend ActionDispatch::TestProcess
      f = fixture_file_upload('event64.xml', 'text/xml')
      Nokogiri::XML(f).xpath("//events/event")
    end
    before { @events = Event.from_xml(xml) }
    specify { @events.count.should == 1 }
    specify { @events[0].origin_ident.should == 64 }
    specify { @events[0].name.should == 'Tuesday AM Facilitator Meeting' }
    specify { @events[0].leader_notes.should == 'Leader notes here' }
    specify { @events[0].starts_at.should == Time.new(2013,11,12,8,45,0) }
    specify { @events[0].ends_at.should == Time.new(2013,11,12,9,30,0) }
    specify { @events[0].recurrence_description.should == 'Nov 12, 2013 at 8:45 AM' }
    specify { @events[0].group.should == "Tues AM Leaders '13-'14" }
    specify { @events[0].organizer.should == 'JoAnn Wert' }
    specify { @events[0].setup_starts_at.should == Time.new(2013,11,12,8,15,0) }
    specify { @events[0].setup_ends_at.should == Time.new(2013,11,12,8,45,0) }
    specify { @events[0].setup_notes.should == 'Setup notes here' }
  end
end
