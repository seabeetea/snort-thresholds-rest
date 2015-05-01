require File.join(File.dirname(__FILE__), "/test_helper.rb")

describe SnortThresholdsRest::Server do

  #Standard working test of all fields
  it 'prints a valid configuration line' do
    post "/thresholds/event_filter/new?sid=123&gid=456&type=limit&track_by=src&count=10&seconds=60&api_key=#{MASTERKEY}"
    json = JSON.parse(last_response.body)
    expect(json['thresholds'].include?('event_filter gen_id 456, sig_id 123, type limit, track by_src, count 10, seconds 60')).to eq true
  end

  #Standard working test of all fields
  it 'prints a valid configuration line' do
    post "/thresholds/event_filter/new?sid=123&gid=456&type=limit&track_by=src&count=10&seconds=60&comment=#{CGI.escape 'This is a good line [smm]'}&api_key=#{MASTERKEY}"
    json = JSON.parse(last_response.body)
    expect(json['thresholds'].include?('event_filter gen_id 456, sig_id 123, type limit, track by_src, count 10, seconds 60#This is a good line [smm]')).to eq true
  end

  #Standard working test of all fields
  it 'prints a valid configuration line' do
    post "/thresholds/event_filter/new?sid=123&gid=456&type=limit&track_by=src&count=10&seconds=60&comment=#{CGI.escape 'This is a good line [smm]'}&api_key=#{MASTERKEY}"
    get "/thresholds/event_filter?sid=123&gid=456"
    json = JSON.parse(last_response.body)
    expect(json['thresholds'].include?('event_filter gen_id 456, sig_id 123, type limit, track by_src, count 10, seconds 60#This is a good line [smm]')).to eq true
  end

  #Standard working test of all fields
  it 'prints a valid configuration line' do
    post "/thresholds/event_filter/new?sid=123&gid=456&type=limit&track_by=src&count=10&seconds=60&comment=#{CGI.escape 'This is a good line [smm]'}&api_key=#{MASTERKEY}"
    get "/thresholds/event_filter?sid=123&gid=222"
    json = JSON.parse(last_response.body)
    expect(json['thresholds'].include?('event_filter gen_id 456, sig_id 123, type limit, track by_src, count 10, seconds 60#This is a good line [smm]')).to eq false
  end

  #Test failure missing sid
  it 'should raise an Invalid EventFilter Object Error' do
    post "/thresholds/event_filter/new?gid=456&type=limit&track_by=src&count=10&seconds=60&api_key=#{MASTERKEY}"
    expect(last_response.ok?).to eq false
  end

  #Test failure missing gid
  it 'should raise an Invalid EventFilter Object Error' do
    post "/thresholds/event_filter/new?sid=123&type=limit&track_by=src&count=10&seconds=60&api_key=#{MASTERKEY}"
    expect(last_response.ok?).to eq false
  end

  #Test failure missing type
  it 'should raise an Invalid EventFilter Object Error' do
    post "/thresholds/event_filter/new?sid=123&gid=456&track_by=src&count=10&seconds=60&api_key=#{MASTERKEY}"
    expect(last_response.ok?).to eq false
  end

  #Test failure missing track_by
  it 'should raise an Invalid EventFilter Object Error' do
    post "/thresholds/event_filter/new?sid=123&gid=456&type=limit&count=10&seconds=60&api_key=#{MASTERKEY}"
    expect(last_response.ok?).to eq false
  end

  #Test failure missing count
  it 'should raise an Invalid EventFilter Object Error' do
    post "/thresholds/event_filter/new?sid=123&gid=456&type=limit&track_by=src&seconds=60&api_key=#{MASTERKEY}"
    expect(last_response.ok?).to eq false
  end

  #Test failure missing seconds
  it 'should raise an Invalid EventFilter Object Error' do
    post "/thresholds/event_filter/new?sid=123&gid=456&type=limit&track_by=src&count=10&api_key=#{MASTERKEY}"
    expect(last_response.ok?).to eq false
  end

  #Test failure invalid sid
  it 'should raise an Invalid EventFilter Object Error' do
    post "/thresholds/event_filter/new?sid=123a&gid=456&type=limit&track_by=src&count=10&seconds=60&api_key=#{MASTERKEY}"
    expect(last_response.ok?).to eq false
  end

  #Test failure invalid gid
  it 'should raise an Invalid EventFilter Object Error' do
    post "/thresholds/event_filter/new?sid=123&gid=456a&type=limit&track_by=src&count=10&seconds=60&api_key=#{MASTERKEY}"
    expect(last_response.ok?).to eq false
  end

  #Test failure invalid type
  it 'should raise an Invalid EventFilter Object Error' do
    post "/thresholds/event_filter/new?sid=123&gid=456a&type=count&track_by=src&count=10&seconds=60&api_key=#{MASTERKEY}"
    expect(last_response.ok?).to eq false
  end

  #Test failure invalid track_by
  it 'should raise an Invalid EventFilter Object Error' do
    post "/thresholds/event_filter/new?sid=123&gid=456a&type=limit&track_by=both&count=10&seconds=60&api_key=#{MASTERKEY}"
    expect(last_response.ok?).to eq false
  end

  #Test failure invalid count
  it 'should raise an Invalid EventFilter Object Error' do
    post "/thresholds/event_filter/new?sid=123&gid=456a&type=limit&track_by=src&count=once&seconds=60&api_key=#{MASTERKEY}"
    expect(last_response.ok?).to eq false
  end

  #Test failure invalid seconds
  it 'should raise an Invalid EventFilter Object Error' do
    post "/thresholds/event_filter/new?sid=123&gid=456a&type=limit&track_by=src&count=10&seconds=1m&api_key=#{MASTERKEY}"
    expect(last_response.ok?).to eq false
  end

  it 'should create and delete event_filters' do
    post "/thresholds/event_filter/new?sid=123&gid=456&type=limit&track_by=src&count=10&seconds=60&api_key=#{MASTERKEY}"
    expect(last_response.ok?).to eq true
    post "/thresholds/event_filter/delete?sid=123&gid=456&api_key=#{MASTERKEY}"
    expect(last_response.ok?).to eq true
  end

  it 'should create and update event_filters' do
    post "/thresholds/event_filter/new?sid=123&gid=456&type=limit&track_by=src&count=10&seconds=60&api_key=#{MASTERKEY}"
    expect(last_response.ok?).to eq true
    post "/thresholds/event_filter/update?sid=123&gid=456&track_by=dst&api_key=#{MASTERKEY}"
    expect(last_response.ok?).to eq true
    get "/thresholds/event_filter?sid=123&gid=456"
    expect(last_response.ok?).to eq true
    json = JSON.parse(last_response.body)
    expect(json['thresholds'].include?('event_filter gen_id 456, sig_id 123, type limit, track by_dst, count 10, seconds 60')).to eq true
  end

  it 'should create and find event_filters' do
    post "/thresholds/event_filter/new?sid=123&gid=456&type=limit&track_by=src&count=10&seconds=60&api_key=#{MASTERKEY}"
    expect(last_response.ok?).to eq true
    get "/thresholds/event_filter?sid=123&gid=456"
    expect(last_response.ok?).to eq true
    json = JSON.parse(last_response.body)
    expect(json['thresholds'].include?('event_filter gen_id 456, sig_id 123, type limit, track by_src, count 10, seconds 60')).to eq true
  end

end
