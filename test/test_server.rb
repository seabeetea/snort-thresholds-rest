# test_server.rb
class CollectorTest < MiniTest::Unit::TestCase
  include Rack::Test::Methods

  def app
    SnortThresholdsRest::Server
  end

end
