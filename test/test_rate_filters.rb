require File.join(File.dirname(__FILE__), "/test_helper.rb")

describe SnortThresholdsRest::Server do

#Standard working test of all fields
  it 'prints a valid configuration line' do
    post '/thresholds/rate_filter/new?sid=123&gid=456&track_by=src&count=10&new_action=drop&seconds=60&timeout=60'
    json = JSON.parse(last_response.body)
    expect(json['thresholds'].include?('rate_filter gen_id 456, sig_id 123, track by_src, count 10, seconds 60, new_action drop, timeout 60')).to eq true
  end

  it 'prints a valid configuration line' do
    post "/thresholds/rate_filter/new?sid=123&gid=456&track_by=src&count=10&new_action=drop&seconds=60&timeout=60&comment=#{CGI.escape 'Finding the pit of success [smm]'}"
    json = JSON.parse(last_response.body)
    expect(json['thresholds'].include?('rate_filter gen_id 456, sig_id 123, track by_src, count 10, seconds 60, new_action drop, timeout 60#Finding the pit of success [smm]')).to eq true
  end

  it 'should raise an Invalid RateFilter Object Error' do
    post '/thresholds/rate_filter/new?sid=123&track_by=src&count=10&new_action=drop&seconds=60&timeout=60'
    expect(last_response.ok?).to eq false
  end

  #it 'should raise an Invalid RateFilter Object Error' do
  #  post '/thresholds/rate_filter/new?sid=123&gid=456&track_by=src&count=10&new_action=alert&apply_to=1.2.4.5&seconds=60&timeout=60'
  #  expect(last_response.ok?).to eq false
  #end

  it 'should create and delete rate_filters' do
    post '/thresholds/rate_filter/new?sid=123&gid=456&track_by=src&count=10&new_action=drop&seconds=60&timeout=60'
    expect(last_response.ok?).to eq true
    post '/thresholds/rate_filter/delete?sid=123&gid=456'
    expect(last_response.ok?).to eq true
  end

  it 'should create and update rate_filters' do
    post '/thresholds/rate_filter/new?sid=123&gid=456&track_by=src&count=10&new_action=drop&seconds=60&timeout=60'
    expect(last_response.ok?).to eq true
    post '/thresholds/rate_filter/update?sid=123&gid=456&track_by=dst&seconds=90'
    expect(last_response.ok?).to eq true
    get "/thresholds/rate_filter?sid=123&gid=456"
    expect(last_response.ok?).to eq true
    json = JSON.parse(last_response.body)
    expect(json['thresholds'].include?('rate_filter gen_id 456, sig_id 123, track by_dst, count 10, seconds 90, new_action drop, timeout 60')).to eq true
  end

  it 'should create and find rate_filters' do
    post '/thresholds/rate_filter/new?sid=123&gid=456&track_by=src&count=10&new_action=drop&seconds=60&timeout=60'
    expect(last_response.ok?).to eq true
    get "/thresholds/rate_filter?sid=123&gid=456"
    expect(last_response.ok?).to eq true
    json = JSON.parse(last_response.body)
    expect(json['thresholds'].include?('rate_filter gen_id 456, sig_id 123, track by_src, count 10, seconds 60, new_action drop, timeout 60')).to eq true
  end

end
