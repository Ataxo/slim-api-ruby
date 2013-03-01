# -*- encoding : utf-8 -*-
require './test/test_helper'
class ClientTest < Test::Unit::TestCase    

  context "Client" do

    setup do 
      #destroy clients!
      SlimApi::Client.find(:ico => "1234").each do |client|
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
      assert client.errors.to_hash.is_a?(Hash), "errors should be a Hash"
    end

    should "access attributes by hash style! -> backward compatibility" do
      client = SlimApi::Client.new(:name => "test")
      assert_equal client.name, "test", "by method"
      assert_equal client[:name], "test", "by hash"
    end

    should "set attributes by hash style! -> backward compatibility" do
      client = SlimApi::Client.new()
      client.name = "test"
      assert_equal client.name, "test", "by method"
      client[:name] = "test2"
      assert_equal client.name, "test2", "by hash"
    end

    should "exists? attributes by hash style! -> backward compatibility" do
      client = SlimApi::Client.new()
      client.name = "test"
      assert client.name?, "name by method exists"
      assert client[:name], "name by hash exists"
      refute client.nonexisting?, "nonexisting by method exists"
      refute client.has_key?(:nonexisting), "nonexisting by method exists"
    end

  end
end
