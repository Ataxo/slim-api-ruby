# -*- encoding : utf-8 -*-

module SlimApi
  module SlimObject

    def self.included(base)
      base.class_eval do
        extend ClassMethods
        include InstanceMethods
      end
    end

    module ClassMethods

      def errors
        @errors ||= []
      end

      def all
        find limit: -1
      end

      def create args = {}
        if args.is_a?(Hash)
          request(:post, args)
        else
          request(:post, args, :bulk)
        end
      end

      def delete args = {}
        request(:delete, args)
      end

      def get id
        response = request(:get, id)
        if response[:status] == "ok"
          new(response[self::NAME])
        else
          puts "SlimApi - Error Getting #{self::NAME} by id #{id}: #{response[:error_type]} - #{response[:message]}"
          @errors = ["#{response[:error_type]} - #{response[:message]}"]
          return nil
        end
      end

      def find args = {}
        find_args = SlimApi.find_options.merge(args)
        response = request(:find, find_args)
        if response[:status] == "ok"
          out = response[self::NAME.to_s.pluralize.to_sym].collect{ |arg|
            new(arg.symbolize_keys).exists!
          }
          array = SlimArray.new out
          array.find_options = find_args
          array.total_count = response[:total_count]
          array.limit = find_args[:limit]
          array.offset = find_args[:offset]
          array.find_object = self
          array
        else
          raise "#{response[:error_type]} - #{response[:message]}"
        end
      end

      def request verb, params = {}, method = nil

        curl = Curl::Easy.new 
        curl.headers["Api-Token"] = SlimApi.api_token
        curl.headers["Content-Type"] = "application/json"
        curl.verbose = false
        curl.resolve_mode = :ipv4

        #set right url dependetnly on verb
        url = SlimApi.api_url(self::NAME, method)
        case verb
        when :find then
          curl.url = url+ (params ? "?#{params.to_query}" : "")
        when :get then
          if params && params.is_a?(Hash)
            curl.url = url+ (params ? "?#{params.to_query}" : "")
          else
            curl.url = url+"/#{params}"
          end
        when :post then
          curl.url = url
        when :put then
          curl.url = url+ (params.is_a?(Hash) && params[:id] ? "/#{params[:id]}" : "")
        when :delete then
          curl.url = url+ (params.is_a?(Hash) && params[:id] ? "/#{params[:id]}" : "")
        end

        #set body for creation and update and delete
        unless verb == :get
          curl.post_body = Yajl::Encoder.encode(params)
        end

        curl.http (verb == :find ? :get : verb).to_s.upcase
        response = Yajl::Parser.parse(curl.body_str, symbolize_keys: true)
      end

    end 

    module InstanceMethods
      def exists!
        @exists = true
        self
      end

      def exists?
        @exists
      end
      alias :persisted? :exists?

      def save
        if exists?
          update
        else
          response = self.class.request(:post, self)
          if response[:status] == "ok"
            exists!
            if response[self.class::NAME].is_a?(Hash)
              self.id = response[self.class::NAME][:id]
            end
            true
          elsif response[:error_type] == "ApiError::BadRequest"
            if response[self.class::NAME] && response[self.class::NAME][:_errors]
              @errors = response[self.class::NAME][:_errors]
            else
              @errors = response[:message]
            end
            false
          else
            raise "#{response[:error_type]} - #{response[:message]}"
          end
        end
      end

      def update
        response = self.class.request(:put, self)
        if response[:status] == "ok"
          self.id = response[self.class::NAME][:id]
          true
        elsif response[:error_type] == "ApiError::BadRequest"
          @errors = response[:message]
          false
        else
          raise "#{response[:error_type]} - #{response[:message]}"
        end
      end

      def destroy!
        if exists?
          response = self.class.request(:delete, self)
          if response[:status] == "ok"
            true
          elsif response[:error_type] == "ApiError::BadRequest"
            @errors = response[:message]
            false
          else
            raise "#{response[:error_type]} - #{response[:message]}"
          end
        end
      end

      def update_attributes args = {}
        self.merge!{args.symbolize_keys}
        update
      end

      def errors
        @errors ||= []
      end

    end

  end
end