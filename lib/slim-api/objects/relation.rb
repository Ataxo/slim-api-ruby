# -*- encoding : utf-8 -*-

module SlimApi
  class Relation

    include SlimObject

    NAME = :relation
    PRIMARY_KEY = :id

    def contract
      @_contract ||= Contract.find(self[:campaign_id])
    end

    def campaign
      @_campaign ||= Campagin.find(self[:campaign_id])
    end
  end
end