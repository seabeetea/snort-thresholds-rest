require File.join(File.dirname(__FILE__), "/test_helper.rb")

describe SnortThresholdsRest::Server do

  #Standard SID and GID test with no additional data
  it 'prints a valid configuration line' do
    post "/thresholds/suppression/new?sid=123&gid=456&api_key=#{MASTERKEY}"
    json = JSON.parse(last_response.body)
    expect(json['thresholds'].include?('suppress gen_id 456, sig_id 123')).to eq true
  end

  #Standard SID GID Track by_src and IP test
  it 'prints a valid configuration line' do
    post "/thresholds/suppression/new?sid=123&gid=456&track_by=src&ip=1.2.3.4&api_key=#{MASTERKEY}"
    json = JSON.parse(last_response.body)
    expect(json['thresholds'].include?('suppress gen_id 456, sig_id 123, track by_src, ip 1.2.3.4')).to eq true
  end

  #Standard SID GID Track by_dst and IP test
  it 'prints a valid configuration line' do
    post "/thresholds/suppression/new?sid=123&gid=456&track_by=dst&ip=1.2.3.4&api_key=#{MASTERKEY}"
    json = JSON.parse(last_response.body)
    expect(json['thresholds'].include?('suppress gen_id 456, sig_id 123, track by_dst, ip 1.2.3.4')).to eq true
  end

  #Standard SID GID Track by_dst and full IP length test
  it 'prints a valid configuration line' do
    post "/thresholds/suppression/new?sid=123&gid=456&track_by=dst&ip=100.200.103.114&api_key=#{MASTERKEY}"
    json = JSON.parse(last_response.body)
    expect(json['thresholds'].include?('suppress gen_id 456, sig_id 123, track by_dst, ip 100.200.103.114')).to eq true
  end

  #Standard SID GID Track by_src and double digit CIRD IP test
  it 'prints a valid configuration line' do
    post "/thresholds/suppression/new?sid=123&gid=456&track_by=dst&ip=1.2.3.4/20&api_key=#{MASTERKEY}"
    json = JSON.parse(last_response.body)
    expect(json['thresholds'].include?('suppress gen_id 456, sig_id 123, track by_dst, ip 1.2.3.4/20')).to eq true
  end

  #Standard SID GID Track by_src and single digit CIRD IP test
  it 'prints a valid configuration line' do
    post "/thresholds/suppression/new?sid=123&gid=456&track_by=dst&ip=1.2.3.4/8&api_key=#{MASTERKEY}"
    json = JSON.parse(last_response.body)
    expect(json['thresholds'].include?('suppress gen_id 456, sig_id 123, track by_dst, ip 1.2.3.4/8')).to eq true
  end

  #Standard SID GID Track by_src and single digit CIRD IP test
  it 'prints a valid configuration line' do
    post "/thresholds/suppression/new?sid=123&gid=456&track_by=dst&ip=1.2.3.4/8&comment=#{CGI.escape 'More good lines [smm]'}&api_key=#{MASTERKEY}"
    json = JSON.parse(last_response.body)
    expect(json['thresholds'].include?('suppress gen_id 456, sig_id 123, track by_dst, ip 1.2.3.4/8#More good lines [smm]')).to eq true
  end

  #Test failure if CIDR is too long
  it 'should raise an Invalid Suppression Object Error' do
    post "/thresholds/suppression/new?sid=123&gid=456&track_by=src&ip=1.2.3.4/208&api_key=#{MASTERKEY}"
    expect(last_response.ok?).to eq false
  end

  #Test failure of no IP set but Track by_ set
  it 'should raise an Invalid Suppression Object Error' do
    post "/thresholds/suppression/new?sid=123&gid=456&track_by=src&api_key=#{MASTERKEY}"
    expect(last_response.ok?).to eq false
  end

  #Test failure on SID and Track by_ set with no GID or IP set
  it 'should raise an Invalid Suppression Object Error' do
    post "/thresholds/suppression/new?sid=123&track_by=src&api_key=#{MASTERKEY}"
    expect(last_response.ok?).to eq false
  end

  #Test failure on SID set but no GID
  it 'should raise an Invalid Suppression Object Error' do
    post "/thresholds/suppression/new?sid=123&api_key=#{MASTERKEY}"
    expect(last_response.ok?).to eq false
  end

  #Test failure on GID set with no SID
  it 'should raise an Invalid Suppression Object Error' do
    post "/thresholds/suppression/new?gid=234&api_key=#{MASTERKEY}"
    expect(last_response.ok?).to eq false
  end

  #Test failure on too many octects in IP
  it 'should raise an Invalid Suppression Object Error' do
    post "/thresholds/suppression/new?sid=123&gid=456&track_by=src&ip=1.2.3.4.5&api_key=#{MASTERKEY}"
    expect(last_response.ok?).to eq false
  end

  #Test failure on invalid IP address
  it 'should raise an Invalid Suppression Object Error' do
    post "/thresholds/suppression/new?sid=123&gid=456&track_by=src&ip=100.200.300.400&api_key=#{MASTERKEY}"
    expect(last_response.ok?).to eq false
  end

  #Test failure on invalid CIDR range of 0
  it 'should raise an Invalid Suppression Object Error' do
    post "/thresholds/suppression/new?sid=123&gid=456&track_by=src&ip=1.2.3.4/0&api_key=#{MASTERKEY}"
    expect(last_response.ok?).to eq false
  end

  #Test failure if SID contains letters
  it 'should raise an Invalid Suppression Object Error' do
    post "/thresholds/suppression/new?sid=123a&gid=456&track_by=src&ip=1.2.3.4&api_key=#{MASTERKEY}"
    expect(last_response.ok?).to eq false
  end

  #Test failure if GID contains letters
  it 'should raise an Invalid Suppression Object Error' do
    post "/thresholds/suppression/new?sid=123&gid=456a&track_by=src&ip=1.2.3.4&api_key=#{MASTERKEY}"
    expect(last_response.ok?).to eq false
  end

  it 'should create and delete suppressions' do
    post "/thresholds/suppression/new?sid=123&gid=456&api_key=#{MASTERKEY}"
    expect(last_response.ok?).to eq true
    post "/thresholds/suppression/delete?sid=123&gid=456&api_key=#{MASTERKEY}"
    expect(last_response.ok?).to eq true
  end

  it 'should create and update suppressions' do
    post "/thresholds/suppression/new?sid=123&gid=456&api_key=#{MASTERKEY}"
    expect(last_response.ok?).to eq true
    post "/thresholds/suppression/update?sid=123&gid=456&track_by=src&ip=1.1.1.1&comment=#{CGI.escape 'comment goes here'}&api_key=#{MASTERKEY}"
    expect(last_response.ok?).to eq true
  end

  it 'should create and find suppressions' do
    post "/thresholds/suppression/new?sid=123&gid=456&api_key=#{MASTERKEY}"
    expect(last_response.ok?).to eq true
    get "/thresholds/suppression?sid=123&gid=456"
    expect(last_response.ok?).to eq true
    json = JSON.parse(last_response.body)
    expect(json['thresholds'].include?('suppress gen_id 456, sig_id 123')).to eq true
  end
end
