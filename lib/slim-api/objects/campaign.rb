# -*- encoding : utf-8 -*-

module SlimApi
  class Campaign < Hashr
    
    include SlimObject

    NAME = :campaign

    def stats args = {}
      Statistics.find(args.merge(campaign_id: self[:id]))
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