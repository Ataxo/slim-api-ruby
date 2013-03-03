# -*- encoding : utf-8 -*-
require './test/test_helper'
class SLimQueryTest < Test::Unit::TestCase    

  context "SlimQuery" do

    setup do 
      @query =SlimApi::SlimQuery.new(SlimApi::Client)
    end

    should "initialize" do
      assert @query.is_a?(SlimApi::SlimQuery), "Result should be slimapi query"
      assert_equal @query.klass, SlimApi::Client, "Should have setted right klass"
    end

    should "have method for order" do
      query = @query.order("id desc")
      assert_equal query.order_values, ["id desc"]
      query = query.order("campaign desc")
      assert_equal query.order_values, ["id desc", "campaign desc"]

      assert_equal query.explain, {:order=>"id desc,campaign desc"}
    end

    should "have method for limit" do
      assert_equal @query.limit_value, nil
      query = @query.limit(25)
      assert_equal query.limit_value, 25

      assert_equal query.explain, {:limit=>25}
    end

    should "have method for offset" do
      assert_equal @query.offset_value, nil
      query = @query.offset(35)
      assert_equal query.offset_value, 35

      assert_equal query.explain, {:offset=>35}
    end

    should "have method for include" do
      assert_equal @query.includes_values, []
      query = @query.includes("test")
      query = query.includes("test2")
      assert_equal query.includes_values, ["test", "test2"]

      assert_equal query.explain, {:include => "test,test2"}
    end

    should "have method for where" do
      assert_equal @query.where_values, []
      query = @query.where(:name => "test")
      query = query.where(:campaign => {:name => "test2"})
      assert_equal query.where_values, [{:name => "test"}, {:campaign => {:name => "test2"}}]

      assert_equal query.explain, {:name => "test", :"campaign.name" => "test2"}
    end

  end
end
