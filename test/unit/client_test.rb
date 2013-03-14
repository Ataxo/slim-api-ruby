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

    context "query interface - Retrieving a Single Object" do
      setup do
        #Destry objects!
        SlimApi::Client.find(:ico => "1234").each{ |client| client.destroy! }
        SlimApi::Client.find(:ico => "12345").each{ |client| client.destroy! }
        #create object!
        @client = SlimApi::Client.new(:name => "Test", :ico => "1234", :email => "test@test.cz")
        @client.save
        @client2 = SlimApi::Client.new(:name => "Test2", :ico => "12345", :email => "test@test.cz")
        @client2.save

      end

      should "have query interface" do
        assert SlimApi::Client.query.is_a?(SlimApi::SlimQuery)
      end

      should "Using a Primary Key" do
        assert_not_nil SlimApi::Client.find(@client.id), "Should not be nil"
        assert SlimApi::Client.find(@client.id).is_a?(SlimApi::Client), "Should be client"
      end

      should "return nil / Raise exception on not found" do
        SlimApi.not_found_handling = :nil
        assert SlimApi::Client.find(123456789021232).nil?, "Shoud be nil on nonexisting!"

        SlimApi.not_found_handling = :exception
        assert_raises SlimApiError::NotFound do
          SlimApi::Client.find(123456789021232)
        end
      end

      should "return multiple objects by its ids" do
        assert_equal SlimApi::Client.find([@client.id,@client2.id]).size, 2, "Should return 2 clients"
      end

      should "have where method for search" do
        clients = SlimApi::Client.where(:name => "Test2")
        assert clients.is_a?(SlimApi::SlimQuery), "Result should be slimapi query"
        assert_equal clients.size, 1, "Should return 1 client"
      end

      should "return SlimArray for method (size)" do
        clients = SlimApi::Client.where(:name => "Test2")
        assert clients.is_a?(SlimApi::SlimQuery), "Result should be slimapi query"
        refute clients.loaded?, "Should not be loaded"
        assert_equal clients.size, 1, "Should return 1 client"
        assert clients.loaded?, "Should be loaded after first call"
      end

      should "return SlimArray for method (each)" do
        clients = SlimApi::Client.where(:name => "Test2")
        assert clients.is_a?(SlimApi::SlimQuery), "Result should be slimapi query"
        refute clients.loaded?, "Should not be loaded"
        clients.each do |client|
          assert client.is_a?(SlimApi::Client), "Should be client"
        end
        assert clients.loaded?, "Should be loaded after first call"
      end

      should "return SlimArray for method (to_a)" do
        clients = SlimApi::Client.where(:name => "Test2")
        assert clients.is_a?(SlimApi::SlimQuery), "Result should be slimapi query"
        refute clients.loaded?, "Should not be loaded"
        assert clients.to_a.is_a?(SlimApi::SlimArray), "Should be slim api array"
        assert clients.loaded?, "Should be loaded after first call"
      end

      should "return SlimArray for method (to_a)" do
        clients = SlimApi::Client.where(:name => "Test2")
        assert clients.is_a?(SlimApi::SlimQuery), "Result should be slimapi query"
        refute clients.loaded?, "Should not be loaded"
        assert clients.all?{|c| c.is_a?(SlimApi::Client)}, "All should be clients"
        assert clients.loaded?, "Should be loaded after first call"
      end

      should "have method for order" do
        clients = SlimApi::Client.order("id desc")
        assert clients.is_a?(SlimApi::SlimQuery), "Result should be slimapi query"
      end

      should "have method for limit" do
        clients = SlimApi::Client.limit(25)
        assert clients.is_a?(SlimApi::SlimQuery), "Result should be slimapi query"
      end

      should "have method for offset" do
        clients = SlimApi::Client.offset(35)
        assert clients.is_a?(SlimApi::SlimQuery), "Result should be slimapi query"
      end

      should "have method for include" do
        clients = SlimApi::Client.includes("test")
        clients = clients.includes("test2")
        assert clients.is_a?(SlimApi::SlimQuery), "Result should be slimapi query"
      end


      context "nested objects" do
        setup do
          @category = SlimApi::Category.new(:category => "Test")
          unless @category.save
            @category = SlimApi::Category.find(:category => "Test").first
          end
          @user = SlimApi::User.new(:id => 121, :user => "Testing user")
          @user.save

          @contract = SlimApi::Contract.new(:category_id => @category.id, :admin_id => 121, :client_id => @client.id, :product => "test", :landing_page => "http://test.cz")
          @contract.save
        end

        should "have nested contracts" do
          clients = SlimApi::Client.where(:id => @client.id).includes(:contracts)
          assert_equal clients.size, 1, "Should return 1 client"
          client = clients.first
          pp client
          assert_not_nil client.instance_variable_get("@_contracts")

          assert client.instance_variable_get("@_contracts").is_a?(SlimApi::SlimArray), "Contracts should have SimApi array"

          assert_equal client.instance_variable_get("@_contracts").size, 1, "Should have one contract"
          assert client.instance_variable_get("@_contracts").first.is_a?(SlimApi::Contract), "Should be contract"

          assert_not_nil client.contracts.first.id
        end

        should "have defined belongs_to relation" do
          assert SlimApi::Contract.instance_methods.include?(:category)
          contract = SlimApi::Contract.find(@contract.id)
          assert_equal contract.category.category, "Test"
        end

        should "have defined has_many relation" do
          assert SlimApi::Contract.instance_methods.include?(:statistics)
          contracts = SlimApi::Client.find(@client.id).contracts
          assert contracts.is_a?(SlimApi::SlimQuery)
          assert_equal contracts.to_a.size, 1
        end
      end
    end

  end
end
