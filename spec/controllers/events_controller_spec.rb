require 'spec_helper'

describe EventsController do
  describe "#index" do
    it "returns HTTP success" do
      get :index, format: :ics
      response.should be_success
    end
  end
end
