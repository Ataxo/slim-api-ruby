# -*- encoding : utf-8 -*-

module SlimApi
  class Contract

    include SlimObject

    NAME = :contract
    PRIMARY_KEY = :id

    def client
      if @_client
        @_client
      elsif client = Client.find(self[:client_id])
        @_client = client
      else
        nil
      end
    end

    def campaign
      if @_campaign
        @_campaign
      elsif campaign = Campaign.find(self[:id])
        @_campaign = campaign
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