require 'json'
require 'threshold'
require_relative 'config'
require_relative 'lib/pingable_server'

module SnortThresholdsRest

    class Server < PingableServer

      get '/' do
        redirect '/ping'
      end

      get '/tresholds' do
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

      get '/thresholds/valid' do
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

      get '/thresholds/hash' do
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
      get '/thresholds/suppression/new' do
        begin
          content_type :json

          s = Threshold::Suppression.new
          s.gid = params['gid'].to_i
          s.sid = params['sid'].to_i
          s.track_by = params['track_by']
          s.ip = params['ip']
          s.comment = params['comment'] if params['comment']
          s.comment = "##{s.comment}" if s.comment and s.comment[0] != '#'

          begin
            s.to_s
          rescue
            return badrequest "invalid suppression"
          end

          t = Threshold::Thresholds.new
          t.file = DATAFILE
          t.loadfile
          t << s
          t.flush

          return { 'thresholds' => t.to_a }.to_json
        rescue
          return internalerror 'there was a problem creating suppression'
        end
      end

      #post '/thresholds/event_filter/new' do
      get '/thresholds/event_filter/new' do
        begin
          content_type :json

          e = Threshold::EventFilter.new
          e.gid = params['gid'].to_i
          e.sid = params['sid'].to_i
          e.type = params['type']
          e.track_by = params['track_by']
          e.count = params['count'].to_i
          e.seconds = params['seconds'].to_i
          e.comment = params['comment'] if params['comment']
          e.comment = "##{e.comment}" if e.comment and e.comment[0] != '#'

          begin
            e.to_s
          rescue
            return badrequest "invalid event filter"
          end

          t = Threshold::Thresholds.new
          t.file = DATAFILE
          t.loadfile
          t << e
          t.flush

          return { 'thresholds' => t.to_a }.to_json
        rescue
          return internalerror 'there was a problem creating event filter'
        end
      end

      #post '/thresholds/rate_filter/new' do
      get '/thresholds/rate_filter/new' do
        begin
          content_type :json

          r = Threshold::RateFilter.new
          r.gid = params['gid'].to_i
          r.sid = params['sid'].to_i
          r.track_by = params['track_by']
          r.count = params['count'].to_i
          r.new_action = params['new_action']
          r.seconds = params['seconds'].to_i
          r.timeout = params['timeout'].to_i
          r.comment = params['comment'] if params['comment']
          r.comment = "##{r.comment}" if r.comment and r.comment[0] != '#'

          begin
            r.to_s
          rescue
            return badrequest "invalid rate filter"
          end

          t = Threshold::Thresholds.new
          t.file = DATAFILE
          t.loadfile
          t << r
          t.flush

          return { 'thresholds' => t.to_a }.to_json
        rescue
          return internalerror 'there was a problem creating rate filter'
        end
      end

      get '/thresholds/*' do
        begin
          content_type :json
          known_actions = ['sort', 'reverse', 'shuffle', 'uniq', 'suppressions', 'event_filters', 'rate_filters']
          actions = []
          params['splat'].each do |p|
            p.split('/').each do |a|
              actions << a
            end
          end

          if (actions - known_actions).count == 0
            t = Threshold::Thresholds.new
            t.file = DATAFILE
            t.loadfile

            t_mod = t
            actions.each do |a|
              t_mod = t_mod.send(a)
            end
            return { 'thresholds' => t_mod.to_a }.to_json
          else
            return badrequest "unknown actions: #{(actions - known_actions).join(',')}"
          end
        rescue
          return internalerror "there was a problem with running actions on thresholds"
        end
      end

    end

end
