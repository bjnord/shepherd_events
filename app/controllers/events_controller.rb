class EventsController < ApplicationController
  respond_to :ics

  def index
    respond_with(@events = Event.all)
  end
end
