require 'spec_helper'
require 'nokogiri'

describe Event do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:starts_at) }
  it { should validate_presence_of(:ends_at) }

  describe '::from_xml' do
    context 'one event with all attributes' do
      let(:xml) do
        extend ActionDispatch::TestProcess
        f = fixture_file_upload('event64.xml', 'text/xml')
        Nokogiri::XML(f).xpath("//events/event")
      end
      before { @events = Event.from_xml(xml) }
      specify { @events.length.should == 1 }
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
      specify { @events[0].resources.length.should == 2 }
      specify { @events[0].exceptions.should be_blank }
    end

    context 'multiple events with a mix of resources and approvals' do
      let(:xml) do
        extend ActionDispatch::TestProcess
        f = fixture_file_upload('mixed_approvals.xml', 'text/xml')
        Nokogiri::XML(f).xpath("//events/event")
      end
      before { @events = Event.from_xml(xml) }
      specify { @events.length.should == 4 }

      it "should set Event#needs_setup? correctly" do
        @events.each do |event|
          case event.origin_ident
          when 64
            event.resources.length.should == 2
            event.should be_setupable
          when 485
            event.resources.length.should == 3
            event.should be_setupable
          when 366
            event.resources.length.should == 2
            event.should_not be_setupable
          when 435
            event.resources.length.should == 0
            event.should_not be_setupable
          end
        end
      end
    end

    context 'one event with exceptions' do
      let(:xml) do
        extend ActionDispatch::TestProcess
        f = fixture_file_upload('with_exceptions.xml', 'text/xml')
        Nokogiri::XML(f).xpath("//events/event")
      end
      before { @events = Event.from_xml(xml) }
      specify { @events.length.should == 1 }

      it "should parse exceptions correctly" do
        @events[0].exceptions.split('|').sort.should == ['2013-12-08T10:00:00','2014-02-09T10:00:00']
      end
    end
  end

  describe '#summary' do
    context 'with only name' do
      subject { FactoryGirl.build(:event, name: "Solitary").summary }
      it { should == "Solitary" }
    end

    context 'with name and group' do
      subject { FactoryGirl.build(:event, name: "Collegial", group: "Chums").summary }
      it { should == "Collegial (Chums)" }
    end
  end

  describe '#notes' do
    context 'with nothing' do
      subject { FactoryGirl.build(:event).notes }
      it { should == "" }
    end

    context 'with only leader_notes' do
      subject { FactoryGirl.build(:event, leader_notes: "Wash").notes }
      it { should == "Leader Notes: Wash" }
    end

    context 'with only setup_notes' do
      subject { FactoryGirl.build(:event, setup_notes: "Dry").notes }
      it { should == "Setup Notes: Dry" }
    end

    context 'with both leader_notes and setup_notes' do
      subject { FactoryGirl.build(:event, leader_notes: "Wash", setup_notes: "Dry").notes }
      it { should == "Leader Notes: Wash\\n\\nSetup Notes: Dry" }
    end

    context 'with leader_notes setup_notes and recurrence_description' do
      subject { FactoryGirl.build(:event, leader_notes: "Wash", setup_notes: "Dry", recurrence_description: "After every meal").notes }
      it { should == "Leader Notes: Wash\\n\\nSetup Notes: Dry\\n\\nRecurrence: After every meal" }
    end

    context 'with recurrence_description that looks like a single date' do
      subject { FactoryGirl.build(:event, recurrence_description: "Nov 5, 2006 at 12:00 AM").notes }
      it { should == "" }
    end

    context 'with leader_notes and organizer' do
      subject { FactoryGirl.build(:event, leader_notes: "Wash", organizer: "Doc").notes }
      it { should == "Leader Notes: Wash\\n\\nOrganizer: Doc" }
    end
  end

  describe '#resource_names' do
    before do
      @event = FactoryGirl.build(:event)
      @event.resources << FactoryGirl.build(:resource, name: 'Laurel')
      @event.resources << FactoryGirl.build(:resource, name: 'Hardy')
    end
    specify { @event.resource_names.should =~ ['Laurel','Hardy'] }
  end

  describe 'setup and teardown time blocks' do
    context 'no setup times' do
      subject { FactoryGirl.build(:event) }
      its(:setup_actually_starts_at) { should be_nil }
      its(:setup_actually_ends_at) { should be_nil }
      its(:teardown_starts_at) { should be_nil }
      its(:teardown_ends_at) { should be_nil }
    end

    context 'setup times completely precede the event' do
      subject { FactoryGirl.build(:event, starts_at: Time.now, setup_starts_at: 1.hour.ago, setup_ends_at: 1.minute.ago) }
      its(:setup_actually_starts_at) { should == subject.setup_starts_at }
      its(:setup_actually_ends_at) { should == subject.setup_ends_at }
      its(:teardown_starts_at) { should be_nil }
      its(:teardown_ends_at) { should be_nil }
    end

    context 'setup times overlap the event start' do
      subject { FactoryGirl.build(:event, starts_at: Time.now, setup_starts_at: 1.hour.ago, setup_ends_at: 1.minute.from_now ) }
      its(:setup_actually_starts_at) { should == subject.setup_starts_at }
      its(:setup_actually_ends_at) { should == subject.starts_at }
      its(:teardown_starts_at) { should be_nil }
      its(:teardown_ends_at) { should be_nil }
    end

    context 'setup times completely encompass the event' do
      subject { FactoryGirl.build(:event, starts_at: Time.now, ends_at: 1.hour.from_now, setup_starts_at: 1.hour.ago, setup_ends_at: 2.hours.from_now ) }
      its(:setup_actually_starts_at) { should == subject.setup_starts_at }
      its(:setup_actually_ends_at) { should == subject.starts_at }
      its(:teardown_starts_at) { should == subject.ends_at }
      its(:teardown_ends_at) { should == subject.setup_ends_at }
    end

    context 'setup times overlap the event end' do
      subject { FactoryGirl.build(:event, starts_at: Time.now, ends_at: 1.hour.from_now, setup_starts_at: 1.minute.from_now, setup_ends_at: 2.hours.from_now ) }
      its(:setup_actually_starts_at) { should be_nil }
      its(:setup_actually_ends_at) { should be_nil }
      its(:teardown_starts_at) { should == subject.ends_at }
      its(:teardown_ends_at) { should == subject.setup_ends_at }
    end

    context 'setup times completely succeed the event' do
      subject { FactoryGirl.build(:event, starts_at: Time.now, ends_at: 1.hour.from_now, setup_starts_at: 1.hour.from_now + 1.minute, setup_ends_at: 2.hours.from_now ) }
      its(:setup_actually_starts_at) { should be_nil }
      its(:setup_actually_ends_at) { should be_nil }
      its(:teardown_starts_at) { should == subject.setup_starts_at }
      its(:teardown_ends_at) { should == subject.setup_ends_at }
    end
  end
end
