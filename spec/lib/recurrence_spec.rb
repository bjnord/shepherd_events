require 'spec_helper'

describe Recurrence do
  describe '::new' do
    pending 'should not alter the string passed into the constructor'

    context 'with daily forever recurrence' do
      subject { Recurrence.new('Every day and is an *ALL DAY* event') }
      its(:rrule) { should == 'FREQ=DAILY' }
    end

    context 'with daily end-dated recurrence' do
      subject { Recurrence.new('Every day until Sep 8, 2013 and is an *ALL DAY* event') }
      its(:rrule) { should == 'FREQ=DAILY;UNTIL=20130908T000000Z' }
    end

    context 'with weekly forever recurrence' do
      subject { Recurrence.new('Every week on Thursday from 7:00 PM to 8:30 PM') }
      its(:rrule) { should == 'FREQ=WEEKLY;BYDAY=TH' }
    end

    context 'with weekly end-dated recurrence' do
      subject { Recurrence.new('Every week on Thursday until Mar 13, 2014 from 7:00 PM to 8:30 PM') }
      its(:rrule) { should == 'FREQ=WEEKLY;UNTIL=20140313T000000Z;BYDAY=TH' }
    end

    context 'with weekly end-dated recurrence and event time' do
      subject { Recurrence.new('Every week on Thursday until Mar 13, 2014 from 7:00 PM to 8:30 PM') }
      let(:etime) { DateTime.parse('2014-02-20T07:14:21Z') }
      specify { subject.rrule(etime).should == 'FREQ=WEEKLY;UNTIL=20140313T071421Z;BYDAY=TH' }
    end

    context 'with 2-weekly end-dated recurrence and event time' do
      subject { Recurrence.new('Every 2 weeks on Thursday until May 20, 2014 from 7:00 PM to 8:15 PM') }
      let(:etime) { DateTime.parse('2014-01-24T07:28:35Z') }
      specify { subject.rrule(etime).should == 'FREQ=WEEKLY;UNTIL=20140520T072835Z;BYDAY=TH;INTERVAL=2' }
    end

    context 'with monthly forever recurrence' do
      subject { Recurrence.new('Every month on the last Saturday of the month from 10:00 AM to 11:30 AM') }
      its(:rrule) { should == 'FREQ=MONTHLY;BYDAY=-1SA' }
    end

    context 'with 3-monthly forever recurrence' do
      subject { Recurrence.new('Every 3 months on the second Friday of the month from 10:00 AM to 11:30 AM') }
      its(:rrule) { should == 'FREQ=MONTHLY;BYDAY=2FR;INTERVAL=3' }
    end

    context 'with monthly end-dated recurrence' do
      subject { Recurrence.new('Every month on the first Saturday of the month until Jun 7, 2014 from 10:00 AM to 11:30 AM') }
      its(:rrule) { should == 'FREQ=MONTHLY;UNTIL=20140607T000000Z;BYDAY=1SA' }
    end

    context 'with an invalid ordinal' do
      specify do
        expect { Recurrence.new('Every month on the twentieth Saturday of the month') }.to raise_error(RecurrenceError, /unknown\s+ordinal/)
      end
    end

    context 'with an unknown monthly recurrence' do
      specify do
        expect { Recurrence.new('Every month on the full moon') }.to raise_error(RecurrenceError, /unknown\s+recurrence/)
      end
    end

    context 'with an unknown recurrence' do
      specify do
        expect { Recurrence.new('Every decade') }.to raise_error(RecurrenceError, /unknown\s+recurrence/)
      end
    end
  end
end
