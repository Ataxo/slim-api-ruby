# -*- encoding : utf-8 -*-

module SlimApi
  class SlimQuery

    attr_accessor :klass, :loaded,
      :where_values, :includes_values, :order_values, :group_values,
      :offset_value, :limit_value

    MULTI_VALUE_METHODS = [:where, :includes, :order, :group]
    SINGLE_VALUE_METHODS = [:limit, :offset]

    #initialize empty query
    def initialize(klass)
      @klass  = klass
      @loaded = false

      SINGLE_VALUE_METHODS.each {|v| instance_variable_set(:"@#{v}_value", nil)}
      MULTI_VALUE_METHODS.each {|v| instance_variable_set(:"@#{v}_values", [])}
    end

    #################################################
    #
    #   Query chaining methods
    #
    #################################################

    # method for adding where conditions
    def where(opts)
      return self if opts.blank?

      query = clone
      query.where_values += build_array_options(opts)
      query
    end

    # method for adding includes
    def includes(opts)
      return self if opts.blank?

      query = clone
      query.includes_values += build_array_options(opts)
      query
    end

    # method for offset set
    def offset(opts)
      return self if opts.blank?

      query = clone
      query.offset_value = opts
      query
    end

    # method for limit set
    def limit(opts)
      return self if opts.blank?

      query = clone
      query.limit_value = opts
      query
    end

    # method for order set
    def order(opts)
      return self if opts.blank?

      query = clone
      query.order_values += build_array_options(opts)
      query
    end

    # method for order set
    def group(opts)
      return self if opts.blank?

      query = clone
      query.group_values += build_array_options(opts)
      query
    end


    # Add new item into existing array
    def build_array_options opts
      return opts if opts.is_a?(Array)
      [opts]
    end

    #################################################
    #
    #   Query load (building & executing query)
    #
    #################################################


    # Is query executed and response is loaded?
    def loaded?
      !!@loaded
    end

    # Return loaded array, if array is not loaded, execute query and load it
    def loaded_array
      exec_query unless loaded?
      @loaded_array
    end


    # Executes query
    def exec_query
      @loaded = true #set loaded to true
      @loaded_array = @klass.find(prepare_query_for_request)
    end


    # return hash for query (what will be send into SlimApi interface)
    def explain
      prepare_query_for_request
    end


    # Prepare all needed conditions for query
    def prepare_query_for_request
      out = {}
      # set parameters (limit, offset)
      SINGLE_VALUE_METHODS.each do |v|
        val = instance_variable_get(:"@#{v}_value")
        out[v] = val if val
      end

      # conditions
      if @where_values.size > 0
        @where_values.each do |condition|
          out.merge!(to_dotted_hash(condition))
        end
      end

      # includes
      if @includes_values.size > 0
        out[:include] = @includes_values.join(",")
      end

      # orders
      if @order_values.size > 0
        out[:order] = @order_values.join(",")
      end

      # groups
      if @group_values.size > 0
        out[:group] = @group_values.join(",")
      end

      #return builded hash
      out
    end


    #Change nested hash into dotted hash:
    # { :campaign => {:name => 'test'}}
    # => { "campaign.name" => 'test'} # this type slimapi recognizes as nested condition
    def to_dotted_hash(source, target = {}, namespace = nil)
      prefix = "#{namespace}." if namespace
      case source
      when Hash
        source.each do |key, value|
          to_dotted_hash(value, target, "#{prefix}#{key}")
        end
      when Array
        source.each_with_index do |value, index|
          to_dotted_hash(value, target, "#{prefix}#{index}")
        end
      else
        target[namespace.to_sym] = source
      end
      target
    end


    #################################################
    #
    #   Enumerable methods on loaded array
    #   (
    #      you need to call any of these methods
    #      to execute query
    #   )
    #
    #################################################

    # return loaded array
    def to_a
      exec_query unless loaded?
      @loaded_array
    end


    # Returns size of the records.
    def size
      exec_query unless loaded?
      @loaded_array.length
    end


    # Returns true if there are no records.
    def empty?
      exec_query unless loaded?
      @loaded_array.empty?
    end


    # Returns true if any of record matches conditions in block or array is not empty
    def any?
      if block_given?
        to_a.any? { |*block_args| yield(*block_args) }
      else
        !empty?
      end
    end


    def many?
      if block_given?
        to_a.many? { |*block_args| yield(*block_args) }
      else
        @limit_value ? to_a.many? : size > 1
      end
    end


    def inspect
      to_a.inspect
    end


    #If you call any of other methods (for enumerable) - delegate it to loaded_array!
    def method_missing(method, *args, &block)
      if loaded_array.respond_to?(method)
        loaded_array.send(method, *args, &block)
      else
        raise NoMethodError
      end
    end

  end
end