require 'sinatra/base'
require 'sys/uptime'
require 'json'
require_relative 'access_server'

class PingableServer < AccessServer
  get '/ping' do
    content_type :json
    begin
      return {
        "uptime" => Sys::Uptime.uptime,
        "date" => Time.now
      }.to_json
    rescue
      return internalerror 'there was a problem getting uptime and date'
    end
  end

end
