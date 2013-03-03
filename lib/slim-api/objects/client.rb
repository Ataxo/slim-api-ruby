# -*- encoding : utf-8 -*-

module SlimApi
  class Client
    
    include SlimObject

    NAME = :client
    PRIMARY_KEY = :id

    def contracts
      @contracts ||= Contract.find(client_id: self[:id])
    end

    def campaigns
      @campaigns ||= Campagin.find(client_id: self[:id])
    end
  end
end