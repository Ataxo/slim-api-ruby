# -*- encoding : utf-8 -*-

module SlimApi
  class Contract < Hashr
    
    include SlimObject

    NAME = :contract

    def client
      if @client
        @client
      elsif (client = Client.find(id: self[:client_id])).size == 1
        @client = client.first
      else
        nil
      end
    end

    def campaign
      if @campaign
        @campaign
      elsif (campaign = Campaign.find(contract_id: self[:id])).size == 1
        @campaign = campaign.first
      else
        nil
      end
    end

    def stats args = {}
      Statistics.find(args.merge(campaign_id: self[:id]))
    end
    alias :statistics :stats
    
  end
end