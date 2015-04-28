# test_helper.rb
ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'minitest/reporters'
require_relative 'support/awesomereporter'

require 'rack/test'
require 'codeclimate-test-reporter'

CodeClimate::TestReporter.start

require_relative '../server.rb'

reporter_options = { color: true, slow_count: 5, slow_threshold: 0.01  }
Minitest::Reporters.use! [Minitest::Reporters::AwesomeReporter.new(reporter_options)]
