# -*- encoding : utf-8 -*-

module SlimApi
  class Client

    include SlimObject

    NAME = :client
    PRIMARY_KEY = :id

    def contracts
      @_contracts ||= Contract.where(client_id: self[:id])
    end

    def campaigns
      @_campaigns ||= Campagin.where(client_id: self[:id])
    end

    def self.find_by_access_hash access_hash
      if (out = find(:access_hash => access_hash)).size == 1
        out.first
      else
        nil
      end
    end
  end
end