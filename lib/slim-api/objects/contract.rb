# -*- encoding : utf-8 -*-

module SlimApi
  class Contract
    
    include SlimObject

    NAME = :contract
    PRIMARY_KEY = :id

    def client
      if @client
        @client
      elsif client = Client.get(self[:client_id])
        @client = client
      else
        nil
      end
    end

    def campaign
      if @campaign
        @campaign
      elsif campaign = Campaign.get(contract_id: self[:id])
        @campaign = campaign
      else
        nil
      end
    end

    def stats
      Statistics.where(campaign_id: self.id)
    end
    alias :statistics :stats
    
    def payments
      Payment.where(campaign_id: self.id)
    end

    def relations
      Relation.where(campaign_id: self.id)
    end

  end
end