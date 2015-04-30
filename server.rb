require 'json'
require 'threshold'
require_relative 'config'
require_relative 'lib/pingable_server'

module SnortThresholdsRest

    class Server < PingableServer

      get '/' do
        redirect '/ping'
      end

      get '/thresholds' do
        begin
          content_type :json
          t = Threshold::Thresholds.new
          t.file = DATAFILE
          t.loadfile
          return { 'thresholds' => t.to_a }.to_json
        rescue
          return internalerror 'there was a problem loading thresholds'
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
          return internalerror 'there was a problem validating thresholds'
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
          return internalerror 'there was a problem getting thresholds hash'
        end
      end

      get /\/thresholds\/(suppressions|event_filters|rate_filters)(?:\/(.*))?/ do
        begin
          content_type :json
          known_types = ['suppressions', 'event_filters', 'rate_filters']
          known_actions = ['sort', 'reverse', 'shuffle', 'uniq']
          actions = []

          if not known_types.include?(params['captures'][0])
            return badrequest "invalid filter type #{params['captures'][0]}"
          end

          if params['captures'][1]
            params['captures'][1].split('/').each do |a|
                actions << a
            end
          end

          if (actions - known_actions).count == 0
            t = Threshold::Thresholds.new
            t.file = DATAFILE
            t.loadfile

            t_mod = t.send(params['captures'][0])
            actions.each do |a|
              t_mod = t_mod.send(a)
            end
            return { 'thresholds' => t_mod.to_a }.to_json
          else
            return badrequest "invalid actions: #{(actions - known_actions).join(', ')}"
          end
        rescue
          return internalerror "there was a problem with running actions on thresholds"
        end
      end

      post '/thresholds/:filter_type/new' do
        begin
          content_type :json

          filter = nil
          if params[:filter_type] == 'suppression'
            filter = Threshold::Suppression.new
          elsif params[:filter_type] == 'event_filter'
            filter = Threshold::EventFilter.new
          elsif params[:filter_type] == 'rate_filter'
            filter = Threshold::RateFilter.new
          else
            return badrequest "invalid filter type #{params[:filter_type]}"
          end

          filter.gid = Integer(params['gid']) if params['gid']
          filter.sid = Integer(params['sid']) if params['sid']
          filter.track_by = params['track_by'] if params['track_by']
          filter.comment = params['comment'] if params['comment']
          filter.comment = "##{filter.comment}" if filter.comment and filter.comment !~ /\s*#/

          if params[:filter_type] == 'suppression'
            filter.ip = params['ip'] if params['ip']
          elsif params[:filter_type] == 'event_filter'
            filter.type = params['type'] if params['type']
            filter.count = Integer(params['count']) if params['count']
            filter.seconds = Integer(params['seconds']) if params['seconds']
          elsif params[:filter_type] == 'rate_filter'
            filter.count = Integer(params['count']) if params['count']
            filter.new_action = params['new_action'] if params['new_action']
            filter.seconds = Integer(params['seconds']) if params['seconds']
            filter.timeout = Integer(params['timeout']) if params['timeout']
          end

          begin
            filter.to_s
          rescue
            return badrequest "invalid #{params[:filter_type]}"
          end

          t = Threshold::Thresholds.new
          t.file = DATAFILE
          t.loadfile
          t << filter
          t.flush
          
          return { 'thresholds' => t.to_a }.to_json
        rescue
          return internalerror "there was a problem creating #{params[:filter_type]}"
        end
      end

      get '/thresholds/:filter_type' do
        begin
          content_type :json

          t = Threshold::Thresholds.new
          t.file = DATAFILE
          t.loadfile

          filter_type = nil
          if params[:filter_type] == 'suppression'
            filter_type = Threshold::Suppression
          elsif params[:filter_type] == 'event_filter'
            filter_type = Threshold::EventFilter
          elsif params[:filter_type] == 'rate_filter'
            filter_type = Threshold::RateFilter
          else
            return badrequest "invalid filter type #{params[:filter_type]}"
          end

          t_new = t.select do |filter|
            filter.is_a?(filter_type) and filter.sid == Integer(params['sid']) and filter.gid == Integer(params['gid'])
          end

          return { 'thresholds' => t_new.to_a }.to_json
        rescue
          return internalerror "there was a problem getting #{params[:filter_type]}"
        end
      end

      post '/thresholds/:filter_type/update' do
        begin
          content_type :json

          t = Threshold::Thresholds.new
          t.file = DATAFILE
          t.loadfile

          filter_type = nil
          if params[:filter_type] == 'suppression'
            filter_type = Threshold::Suppression
          elsif params[:filter_type] == 'event_filter'
            filter_type = Threshold::EventFilter
          elsif params[:filter_type] == 'rate_filter'
            filter_type = Threshold::RateFilter
          else
            return badrequest "invalid filter type #{params[:filter_type]}"
          end

          first_index = t.index.find_index do |filter|
            filter.is_a?(filter_type) and filter.sid == Integer(params['sid']) and filter.gid == Integer(params['gid'])
          end

          if not first_index
            return notfound "#{params[:filter_type]} not found"
          end

          t[first_index].track_by = params['track_by'] if params['track_by']
          t[first_index].comment = params['comment'] if params['comment']
          t[first_index].comment = "##{t[first_index].comment}" if t[first_index].comment and t[first_index].comment !~ /^\s*#/

          if params[:filter_type] == 'suppression'
            t[first_index].ip = params['ip'] if params['ip']
          elsif params[:filter_type] == 'event_filter'
            t[first_index].type = params['type'] if params['type']
            t[first_index].count = Integer(params['count']) if params['count']
            t[first_index].seconds = Integer(params['seconds']) if params['seconds']
          elsif params[:filter_type] == 'rate_filter'
            t[first_index].count = Integer(params['count']) if params['count']
            t[first_index].new_action = params['new_action'] if params['new_action']
            t[first_index].seconds = Integer(params['seconds']) if params['seconds']
            t[first_index].timeout = Integer(params['timeout']) if params['timeout']
          end

          t.flush

          return { 'thresholds' => t.to_a }.to_json
        rescue
          return internalerror "there was a problem updating #{params[:filter_type]}"
        end
      end

      post '/thresholds/:filter_type/delete' do
        begin
          content_type :json

          t = Threshold::Thresholds.new
          t.file = DATAFILE
          t.loadfile

          filter_type = nil
          if params[:filter_type] == 'suppression'
            filter_type = Threshold::Suppression
          elsif params[:filter_type] == 'event_filter'
            filter_type = Threshold::EventFilter
          elsif params[:filter_type] == 'rate_filter'
            filter_type = Threshold::RateFilter
          else
            return badrequest "invalid filter type #{params[:filter_type]}"
          end

          t.reject! do |filter|
            filter.is_a?(filter_type) and filter.sid == Integer(params['sid']) and filter.gid == Integer(params['gid'])
          end

          t.flush

          return { 'thresholds' => t.to_a }.to_json
        rescue
          return internalerror "there was a problem deleting #{params[:filter_type]}"
        end
      end

    end

end
