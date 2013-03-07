# -*- encoding : utf-8 -*-
require './test/test_helper'
class CampaignTest < Test::Unit::TestCase

  context "Campaign" do

    setup do
      #destroy clients!
      SlimApi::Contract.find(:id => "123466666").each do |client|
        client.destroy!
      end
      contract = SlimApi::Contract.new(:id => "123466666", :product => 'sandbox', :client_id => 0, :admin_id => 0, :currency => 'czk', :landing_page => "http://ataxo.cz", :email => "ondrej@bartas.cz")
      contract.save
    end

    should "be found" do
      campaign = SlimApi::Campaign.find("123466666")
      assert campaign
    end

    should "be updated" do
      contract = SlimApi::Contract.find("123466666")
      campaign = contract.campaign
      campaign.status = :pending
      assert campaign.save

      campaign = SlimApi::Campaign.find("123466666")
      assert_equal campaign.status, "pending"
    end
  end
end
