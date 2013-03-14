# -*- encoding : utf-8 -*-

module SlimApi
  class Campaign

    include SlimObject

    NAME = :campaign
    PRIMARY_KEY = :id

    def client
      if @_client
        @_client
      elsif client = Client.get(self[:client_id])
        @_client = client
      else
        nil
      end
    end

    def contract
      if @_contract
        @_contract
      elsif contract = Contract.get(self[:id])
        @_contract = contract
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