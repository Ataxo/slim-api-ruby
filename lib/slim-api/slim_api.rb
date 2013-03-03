# -*- encoding : utf-8 -*-

module SlimApi

  @config = {
    url: "http://slimapi.ataxo.com",
    version: :v1,
    taxonomy: :sandbox,
    api_token: "SlimApi.api_token = 'YOUR TOKEN'",
    #exception handling
    # :nil  - return only nil when not found
    # :exception - return NotFoundException
    not_found_handling: :nil, 
  }
  @find_options = {
    limit: 10, 
    offset: 0
  }

  def self.url= url
    @config[:url] = url
  end

  def self.url
    @config[:url]
  end

  def self.not_found_handling
    @config[:not_found_handling]
  end

  def self.not_found_handling= type
    @config[:not_found_handling] = type
  end

  def self.version= version
    @config[:version] = version
  end

  def self.version
    @config[:version]
  end

  def self.taxonomy= taxonomy
    @config[:taxonomy] = taxonomy
  end

  def self.taxonomy
    @config[:taxonomy]
  end

  def self.api_token= api_token
    @config[:api_token] = api_token
  end

  def self.api_token
    @config[:api_token]
  end

  def self.config
    @config
  end

  def self.config= conf
    @config.merge!(conf)
  end

  def self.api_url object_name, method = nil
    "#{@config[:url]}/#{@config[:version]}/#{@config[:taxonomy]}/#{object_name.to_s.pluralize}#{ method ? "/#{method}" : ""}"
  end

  def self.find_options= opts
    @find_options = opts
  end

  def self.find_options
    Marshal.load(Marshal.dump(@find_options))
  end
end