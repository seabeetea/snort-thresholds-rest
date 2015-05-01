require 'sinatra/base'
require 'sys/uptime'
require 'json'
require_relative '../config'

class AccessServer < Sinatra::Base
  before do
    if !params['api_key']
      halt unauthorized 'missing api key'
    end

    access = lookup_access_by_api_key(params['api_key'])
    if request.request_method == 'POST'
      if !access or !access.include?('0')
        halt unauthorized 'unknown or unauthorized api key'
      end
    elsif request.request_method == 'GET'
      if !access
        halt unauthorized 'unknown or unauthorized api key'
      end
    end
  end

  get '/*' do
    return badrequest 'this request is not supported'
  end

  def lookup_access_by_api_key api_key
    begin
      h = JSON.parse(File.read(APIFILE))
      return h[api_key]
    rescue
      nil
    end
  end

  def error_message msg
    {
      "error" => msg
    }.to_json
  end

  def notfound msg
    content_type :json
    [404, error_message(msg)]
  end

  def badrequest msg
    content_type :json
    [400, error_message(msg)]
  end

  def unauthorized msg
    content_type :json
    [401, error_message(msg)]
  end

  def forbidden msg
    content_type :json
    [403, error_message(msg)]
  end

  def internalerror msg
    content_type :json
    [500, error_message(msg)]
  end

end
