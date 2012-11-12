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
      def all
        find limit: -1
      end

      def find args = {}
        find_args = SlimApi.find_options.merge(args)
        response = request(:get, find_args)
        if response["status"] == "ok"
          out = response["#{self::NAME.to_s.pluralize}"].collect{ |arg|
            new(arg.symbolize_keys).exists!
          }
          array = SlimArray.new out
          array.find_options = find_args
          array.total_count = response["total_count"]
          array.limit = find_args[:limit]
          array.offset = find_args[:offset]
          array.find_object = self
          array
        else
          raise "#{response["error_type"]} - #{response["message"]}"
        end
      end

      def request verb, params = {}
        curl = Curl::Easy.new 
        curl.headers["Api-Token"] = SlimApi.api_token
        curl.verbose = false
        curl.resolve_mode = :ipv4

        #set right url dependetnly on verb
        url = SlimApi.api_url(self::NAME)
        case verb
        when :get then
          curl.url = url+"?#{params.to_query}"
        when :post then
          curl.url = url
        when :put then
          curl.url = url+"/#{params[:id]}"
        when :delete then
          curl.url = url+"/#{params[:id]}"
        end

        #set body for creation and update
        if verb == :post || verb == :put
          curl.post_body = Yajl::Encoder.encode(params)
        end

        curl.http verb.to_s.upcase

        response = Yajl::Parser.parse(curl.body_str)
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

      def save
        if exists?
          update
        else
          response = self.class.request(:post, self)
          if response["status"] == "ok"
            exists!
            self[:id] = response["#{self.class::NAME}"]["id"]
            true
          elsif response["error_type"] == "ApiError::BadRequest"
            @errors = response["message"]
            false
          else
            raise "#{response["error_type"]} - #{response["message"]}"
          end
        end
      end

      def update
        response = self.class.request(:put, self)
        if response["status"] == "ok"
          self.id = response["#{self.class::NAME}"]["id"]
          true
        elsif response["error_type"] == "ApiError::BadRequest"
          @errors = response["message"]
          false
        else
          raise "#{response["error_type"]} - #{response["message"]}"
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