ENV['RACK_ENV'] = "test"

require 'simplecov'
SimpleCov.start do 
  add_filter "/test/"
  add_filter "/config/"

  add_group 'Sinatra', 'app_sinatra'
  add_group 'Unit', 'app/'
  add_group 'Lib', 'lib/'
end

require 'test/unit'
require 'turn'
require 'shoulda-context'

require 'bundler'
Bundler.setup

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'slim-api-ruby'

#Set test case tokens!
SlimApi.api_token = "ff969f7e381c8a0f2c6d85d31301fab1e2f9856d"
SlimApi.taxonomy = "sandbox"
