# -*- encoding : utf-8 -*-

module SlimApi
  class Payment

    include SlimObject

    NAME = :payment
    PRIMARY_KEY = :id

    def contract
      @_contract ||= Contract.find(self[:campaign_id])
    end

    def campaign
      @_campaign ||= Campagin.find(self[:campaign_id])
    end
  end
end