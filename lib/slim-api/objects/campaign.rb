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
      elsif (client = Client.find(id: self[:client_id])).size == 1
        @client = client.first
      else
        nil
      end
    end

    def contract
      if @contract
        @contract
      elsif (contract = Contract.find(id: self[:id])).size == 1
        @contract = contract.first
      else
        nil
      end
    end


  end
end