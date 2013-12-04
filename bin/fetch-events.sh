#!/bin/sh
if [ -e $HOME/shepherd_events/current ]; then
    DIR=$HOME/shepherd_events/current
else
    DIR=$HOME/shepherd_events
fi
cd $DIR || exit
bundle exec rails runner bin/fetch-events -V
