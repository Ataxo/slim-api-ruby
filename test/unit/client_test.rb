# -*- encoding : utf-8 -*-
require './test/test_helper'
class ClientTest < Test::Unit::TestCase    

  context "Client" do

    setup do 
      #destroy clients!
      SlimApi::Client.find(:ico => "1234").each do |client|
        puts client
        client.destroy!
      end
    end

    should "find all" do
      assert clients = SlimApi::Client.find(), "Should not be nil"
      assert clients.is_a?(Array), "Should be array"
    end

    should "create one" do
      client = SlimApi::Client.new(:name => "Test", :ico => "1234", :email => "test@test.cz")
      assert client.save, "Errors: #{client.errors}"

    end

    should "create one with errors" do
      client = SlimApi::Client.new()
      refute client.save, "should not be saved"
      assert client.errors.is_a?(Hash), "errors should be a Hash"
    end


  end
end
