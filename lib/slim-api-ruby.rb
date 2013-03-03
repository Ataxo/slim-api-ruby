# -*- encoding : utf-8 -*-
require 'active_support/inflector'
require 'active_support/core_ext'
require 'active_model'
require 'colorize'

require 'hashr'
require 'curb'
require 'yajl'

require File.join(File.dirname(__FILE__),"slim-api/slim_api")
require File.join(File.dirname(__FILE__),"slim-api/slim_array")
require File.join(File.dirname(__FILE__),"slim-api/slim_object")
require File.join(File.dirname(__FILE__),"slim-api/objects/client")
require File.join(File.dirname(__FILE__),"slim-api/objects/course")
require File.join(File.dirname(__FILE__),"slim-api/objects/contract")
require File.join(File.dirname(__FILE__),"slim-api/objects/campaign")
require File.join(File.dirname(__FILE__),"slim-api/objects/category")
require File.join(File.dirname(__FILE__),"slim-api/objects/statistics")
require File.join(File.dirname(__FILE__),"slim-api/objects/user")
require File.join(File.dirname(__FILE__),"slim-api/objects/import_campaign_statistics")
require File.join(File.dirname(__FILE__),"slim-api/objects/import_keyword_statistics")
