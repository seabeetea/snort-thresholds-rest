#$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])
require 'rubygems'
require 'rack/test'
require 'rspec'
require 'json'
require_relative '../server.rb'
require_relative 'config.rb'

require 'simplecov'
SimpleCov.start

require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

require "threshold"
require 'pry'

MASTERKEY = '35285fe4-c29f-4a2f-9189-6264f1728993'
NOPOSTKEY = '54b22f56-9a84-4893-bc70-332e3b5ded66'

module RSpecMixin
  include Rack::Test::Methods
  def app() SnortThresholdsRest::Server end
end

RSpec.configure { |c| c.include RSpecMixin }

# Require everything in `spec/support`
Dir[File.expand_path('../../test/support/**/*.rb', __FILE__)].map(&method(:require))

=begin
RSpec.configure do |config|
  #config.include Her::Testing::Macros::ModelMacros
  #config.include Her::Testing::Macros::RequestMacros

  config.before :each do
    #@spawned_models = []
  end

  config.after :each do
    #@spawned_models.each do |model|
    #  Object.instance_eval { remove_const model } if Object.const_defined?(model)
    #end
  end
end
=end
