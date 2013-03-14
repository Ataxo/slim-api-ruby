# -*- encoding : utf-8 -*-

module SlimApi
  class Statistics

    include SlimObject

    NAME = :statistics
    PRIMARY_KEY = :campaign_id

    belongs_to :campaign, :campaign_id
    belongs_to :contract, :campaign_id

    def cpc
      return 0.0 if self.clicks.to_f == 0
      (self.price_currency.to_f/self.clicks.to_f) rescue 0.0
    end

    def cpc_czk
      self.price_czk.to_f/self.clicks.to_f rescue 0.0
    end

    def cpc_eur
      self.price_eur.to_f/self.clicks.to_f rescue 0.0
    end

    def ctr
      self.clicks.to_f/self.impressions.to_f*100.0 rescue 0.0
    end

  end
end