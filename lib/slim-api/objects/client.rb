# -*- encoding : utf-8 -*-

module SlimApi
  class Client < Hashr
    
    include SlimObject

    NAME = :client

    def contracts
      @contracts ||= Contract.find(client_id: self[:id])
    end

    def campaigns
      @campaigns ||= Campagin.find(client_id: self[:id])
    end
  end
end