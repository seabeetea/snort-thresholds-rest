require File.join(File.dirname(__FILE__), "/test_helper.rb")

describe SnortThresholdsRest::Server do

  it 'posts with master key' do
    post "/thresholds/suppression/new?sid=123&gid=456&api_key=#{MASTERKEY}"
    expect(last_response.ok?).to eq true
  end

  it 'fails to post with get-only key' do
    post "/thresholds/suppression/new?sid=123&gid=456&api_key=#{NOPOSTKEY}"
    expect(last_response.ok?).to eq false
  end

  it 'gets with master key' do
    get "/thresholds?api_key=#{MASTERKEY}"
    expect(last_response.ok?).to eq true
  end

  it 'gets with get-only key' do
    get "/thresholds?api_key=#{NOPOSTKEY}"
    expect(last_response.ok?).to eq true
  end

  it 'fails to get without key' do
    get "/thresholds"
    expect(last_response.ok?).to eq false
  end

  it 'fails to post without key' do
    post "/thresholds/suppression/new?sid=123&gid=456"
    expect(last_response.ok?).to eq false
  end
end
