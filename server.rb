require 'json'
require 'threshold'
require_relative 'config'
require_relative 'lib/pingable_server'

module SnortThresholdsRest

    class Server < PingableServer

      ['/file/load', '/thresholds'].each do |path|
        get path do
          begin
            content_type :json
            t = Threshold::Thresholds.new
            t.file = DATAFILE
            t.loadfile
            return { 'thresholds' => t.to_a }.to_json
          rescue
            return internalerror 'there was a problem loading file'
          end
        end
      end

      get '/file/valid' do
        begin
          content_type :json
          t = Threshold::Thresholds.new
          t.file = DATAFILE
          t.loadfile
          if t.valid?
            { 'valid' => true }.to_json
          else
            { 'valid' => false }.to_json
          end
        rescue
          return internalerror 'there was a problem validating file'
        end
      end

      get '/file/hash' do
        begin
          content_type :json
          t = Threshold::Thresholds.new
          t.file = DATAFILE
          t.loadfile
          return { 'hash' => t.stored_hash }.to_json
        rescue
          return internalerror 'there was a problem getting file hash'
        end
      end

      # post '/suppression/new' do
      get '/suppression/new' do
        begin
          content_type :json

          if not params['gid'] or not params['sid']
            return badrequest 'must provide gid and sid'
          end

          t = Threshold::Thresholds.new
          t.file = DATAFILE
          t.loadfile

          s = Threshold::Suppression.new
          s.gid = params['gid'].to_i
          s.sid = params['sid'].to_i

          t << s
          t.flush

          return { 'thresholds' => t.to_a }.to_json
        rescue
          return internalerror 'there was a problem creating suppression'
        end
      end

      get '/thresholds/:action' do
        begin
          content_type :json
          t = Threshold::Thresholds.new
          t.file = DATAFILE
          t.loadfile
          # doesn't include: reject, select
          if ['sort', 'reverse', 'shuffle', 'uniq', 'suppressions', 'event_filters', 'rate_filters'].include?(params[:action])
            return { 'thresholds' => t.send(params[:action]).to_a }.to_json
          else
            return badrequest 'unknown action on thresholds'
          end
        rescue
          return internalerror "there was a problem with #{params[:action]}"
        end
      end

    end

end
