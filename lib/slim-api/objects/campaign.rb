# -*- encoding : utf-8 -*-

module SlimApi
  class Campaign
    
    include SlimObject

    NAME = :campaign
    PRIMARY_KEY = :id

    def stats
      Statistics.where(campaign_id: self.id)
    end
    alias :statistics :stats

    def client
      if @client
        @client
      elsif client = Client.get(self[:client_id])
        @client = client
      else
        nil
      end
    end

    def contract
      if @contract
        @contract
      elsif contract = Contract.get(self[:id])
        @contract = contract
      else
        nil
      end
    end


  end
end