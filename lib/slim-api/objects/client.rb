# -*- encoding : utf-8 -*-

module SlimApi
  class Client

    include SlimObject

    NAME = :client
    PRIMARY_KEY = :id

    has_many :contracts, :client_id
    has_many :campaigns, :client_id

    def self.find_by_access_hash access_hash
      if (out = find(:access_hash => access_hash)).size == 1
        out.first
      else
        nil
      end
    end
  end
end