# -*- encoding : utf-8 -*-
require './test/test_helper'

class ActiveModelIntegrationTest < ActiveModel::TestCase
  include ActiveModel::Lint::Tests

  def setup
    @model = SlimApi::Client.new
  end
end