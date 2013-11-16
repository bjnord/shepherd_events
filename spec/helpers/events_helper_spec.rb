require 'spec_helper'

describe EventsHelper do
  describe "#ics_fold" do
    subject { ics_fold(line) }

    context "with nil" do
      let(:line) { nil }
      it { should == "" }
    end

    context "with characters required to be escaped" do
      let(:line) { 'A man, a plan, a canal; Panama \ palindrome' }
      it { should == 'A man\, a plan\, a canal\; Panama \\\\ palindrome' }
    end

    context "with a short line" do
      let(:line) { "major " * 10 }
      it { should == "major " * 10 }
    end

    context "with a long line" do
      let(:line) { "field marshal " * 10 }
      it { should == "field marshal " * 5 + "field\r\n  marshal " + "field marshal " * 4 }
    end

    context "with a very long line" do
      let(:line) { "brigadier " * 50 }
      it { should == ("brigadier " * 7 + "briga\r\n dier " + "brigadier " * 7 + "\r\n ") * 3 + "brigadier " * 5 }
    end
  end
end
