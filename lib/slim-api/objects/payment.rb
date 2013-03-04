# -*- encoding : utf-8 -*-

module SlimApi
  class Payment
    
    include SlimObject

    NAME = :payment
    PRIMARY_KEY = :id

    def contract
      @contract ||= Contract.find(self[:campaign_id])
    end

    def campaign
      @campaign ||= Campagin.find(self[:campaign_id])
    end
  end
end