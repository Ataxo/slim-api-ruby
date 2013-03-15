# -*- encoding : utf-8 -*-

module SlimApi
  module SlimObject

    def self.included(base)
      base.class_eval do
        #active model like
        extend ActiveModel::Naming
        include ActiveModel::AttributeMethods
        include ActiveModel::Conversion
        include ActiveModel::Validations

        #relations has_many, belongs_to
        extend SlimApi::SlimRelations

        extend ClassMethods
        include InstanceMethods
      end
    end

    module ClassMethods

      delegate :order, :limit, :offset,
             :where, :includes, :to => :query

      def errors
        @errors ||= []
      end

      def query
        @query ||= SlimQuery.new(self)
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
          new(response[self::NAME]).sub_model_exists!
        else
          if SlimApi.not_found_handling == :nil
            puts "SlimApi - Error Getting #{self::NAME} by id #{id}: #{response[:error_type]} - #{response[:message]}".red
            @errors = ["#{response[:error_type]} - #{response[:message]}"]
            return nil
          else
            raise "Slim#{response[:error_type]}".constantize, response[:message]
          end
        end
      end

      def find args = {}
        #where || ids list
        if args.is_a?(Hash) || args.is_a?(Array)
          if args.is_a?(Hash)
            find_args = SlimApi.find_options.merge(args)
          else
            find_args = SlimApi.find_options.merge("#{self::PRIMARY_KEY}.in" => args.join(","), :limit => args.size)
          end
          response = request(:find, find_args)
          if response[:status] == "ok"
            out = response[self::NAME.to_s.pluralize.to_sym].collect{ |arg|
              new(arg.symbolize_keys).sub_model_exists!
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
        #only id
        else
          get args
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
        SlimApi.log(header: curl.headers, verb: (verb == :find ? :get : verb), url: curl.url, response: curl.body_str, response_hash: response)
        response
      end

    end

    module InstanceMethods
      INCLUDE_REGEXP = /^_/
      VARIABLE_REGEXP = /^@_/
      LOADED_VARIABLE_REGEXP = /^@_(.+)_loaded$/
      def initialize args = {}
        #set attributes to empty array!
        @attributes = {}

        _update_attributes args

        return self
      end

      #persisted part
      def exists!
        @exists = true
        self
      end

      #persisted part for all sub models
      def sub_model_exists!
        @exists = true
        self.instance_variables.each do |arg|
          if arg.to_s =~ VARIABLE_REGEXP && arg.to_s !~ LOADED_VARIABLE_REGEXP
            obj = self.instance_variable_get(arg)
            if obj.is_a?(Array)
              obj.each{|o| o.sub_model_exists! }
            else
              obj.sub_model_exists!
            end
          end
        end
        self
      end

      def exists?
        !!@exists
      end
      alias :persisted? :exists?

      def add_errors response
        response[self.class::NAME][:_errors].each do |err, messages|
          messages.each do |message|
            errors.add err, message
          end
        end
      end

      def save
        if exists?
          update
        else
          response = self.class.request(:post, @attributes)
          if response[:status] == "ok"
            exists!
            if response[self.class::NAME].is_a?(Hash)
              _update_attributes response[self.class::NAME]
            end
            true
          elsif response[:error_type] == "ApiError::BadRequest"
            if response[self.class::NAME] && response[self.class::NAME][:_errors]
              add_errors response
            else
              errors.add response[:message]
            end
            false
          else
            raise "#{response[:error_type]} - #{response[:message]}"
          end
        end
      end

      def update
        response = self.class.request(:put, @attributes)
        if response[:status] == "ok"
          _update_attributes response[self.class::NAME]
          true
        elsif response[:error_type] == "ApiError::BadRequest"
          if response[self.class::NAME] && response[self.class::NAME][:_errors]
            add_errors response
          else
            errors.add response[:message]
          end
          false
        else
          raise "#{response[:error_type]} - #{response[:message]}"
        end
      end

      def destroy!
        if exists?
          response = self.class.request(:delete, @attributes)
          if response[:status] == "ok"
            true
          elsif response[:error_type] == "ApiError::BadRequest"
            errors.add response[:message]
            false
          else
            raise "#{response[:error_type]} - #{response[:message]}"
          end
        end
      end

      def update_attributes args = {}
        _update_attributes args
        update
      end

      def to_json
        Yajl::Encoder.encode(@attributes)
      end

      def to_hash
        @attributes
      end

      def _update_attributes args = {}
        if args.is_a?(Hash)
          input_args = args.symbolize_keys
          input_args.each do |key, value|
            #all keys starting '_' as '_client' are included models
            if key.to_s =~ INCLUDE_REGEXP && key.to_s != "_errors"
              sub_klass = "SlimApi::#{key.to_s.gsub(INCLUDE_REGEXP, "").singularize.camelize}".constantize
              #array of objects
              if value.is_a?(Array)
                out = value.collect{ |arg|
                  sub_klass.new(arg.symbolize_keys)
                }
                array = SlimArray.new out
                array.find_options = {}
                array.total_count = value.size
                array.limit = value.size
                array.offset = 0
                array.find_object = sub_klass
                instance_variable_set("@#{key}_loaded", true)
                instance_variable_set("@#{key}", array)
              else
                instance_variable_set("@#{key}_loaded", true)
                instance_variable_set("@#{key}", sub_klass.new(value))
              end
            else
              send("#{key}=", value)
            end
          end
        end
      end

      #BACKWARDS COMPATIBILITY FOR USING AS HASH!
      def [](key, default = nil)
        if @attributes.has_key?(key)
          @attributes[key.to_sym]
        else
          nil
        end
      end

      def []=(key, value)
        @attributes[key.to_sym] = value
      end

      def method_missing(name, *args, &block)
        case name.to_s[-1, 1]
        when '?'
          !!@attributes[name.to_s[0..-2].to_sym]
        when '='
          @attributes[name.to_s[0..-2].to_sym] = args.first
        else
          @attributes[name]
        end
      end

    end

  end
end