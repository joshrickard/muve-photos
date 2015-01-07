#!/bin/bash

cd /Users/josh/dev/muve-photos/aggregator/

source /Users/josh/.rvm/environments/ruby-2.1.5@global

bundle install
ruby harvest.rb
