# -*- encoding : utf-8 -*-
require './test/test_helper'
class PaymentTest < Test::Unit::TestCase    

  context "Payment" do

    should "find all" do
      assert payment = SlimApi::Payment.find(), "Should not be nil"
      assert payment.is_a?(Array), "Should be array"
      assert_equal payment.size, 1, "Should be array of size 1 -> summary"
    end

    should "create one" do
      SlimApi::Payment.where(:campaign_id => "333").includes(:id).each do |payment|
        payment.destroy!
      end
      payment = SlimApi::Payment.new(:campaign_id => 333, :date => Date.today, :currency => 'czk', :price_currency => 20, :payment_type => 'charge')
      assert payment.save, "Errors: #{payment.errors}"
    end

    should "create one with errors" do
      payment = SlimApi::Payment.new()
      refute payment.save, "should not be saved"
      assert payment.errors.to_hash.is_a?(Hash), "errors should be a Hash"
    end

    context "query interface - Retrieving a Single Object" do
      setup do
        SlimApi::Payment.where(:campaign_id => "333").includes(:id).each do |payment|
          payment.destroy!
        end

        #create object!
        @payment = SlimApi::Payment.new(:campaign_id => 333, :date => Date.today-2, :currency => 'czk', :price_currency => 20, :payment_type => 'charge')
        @payment.save
        @payment2 = SlimApi::Payment.new(:campaign_id => 333, :date => Date.today, :currency => 'czk', :price_currency => -20, :payment_type => 'media_cost')
        @payment2.save

      end

      should "have query interface" do
        assert SlimApi::Payment.query.is_a?(SlimApi::SlimQuery)
      end

      should "return summary" do
        summary = SlimApi::Payment.find(:campaign_id => 333).first
        assert_equal summary.price_czk, 0, "in this case price currency should be 0 (20-20 = 0)"
        @payment3 = SlimApi::Payment.new(:campaign_id => 333, :date => Date.today-10, :currency => 'czk', :price_currency => 1030, :payment_type => 'charge')
        @payment3.save
        summary = SlimApi::Payment.find(:campaign_id => 333).first
        assert_equal summary.price_czk, 1030, "in this case price currency should be 1030 (20-20+1030 = 1030)"
      end

      should "return every payment when id included" do
        all_payments = SlimApi::Payment.where(:campaign_id => 333).includes(:id)
        assert_equal all_payments.size, 2, "should have two payments"
      end

    end

  end
end
