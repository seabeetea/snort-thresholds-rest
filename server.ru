require 'bundler'
Bundler.require
require_relative 'server'
run SnortThresholdsRest::Server
