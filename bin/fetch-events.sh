#!/usr/bin/env bash
if [ -e $HOME/shepherd_events/current ]; then
    DIR=$HOME/shepherd_events/current
else
    DIR=$HOME/shepherd_events
fi
RAILS_ENV=production
export RAILS_ENV DIR
cd $DIR || exit
source /usr/local/rvm/environments/ruby-2.0.0-p353
rails runner bin/fetch-events -V
