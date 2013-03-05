# -*- encoding : utf-8 -*-

module SlimApi
  class Client
    
    include SlimObject

    NAME = :client
    PRIMARY_KEY = :id

    def contracts
      @contracts ||= Contract.where(client_id: self[:id])
    end

    def campaigns
      @campaigns ||= Campagin.where(client_id: self[:id])
    end
  end
end