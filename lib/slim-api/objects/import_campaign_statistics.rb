# -*- encoding : utf-8 -*-

module SlimApi
  class ImportCampaignStatistics < Hashr
    
    include SlimObject

    NAME = :import_campaign_statistics

    def self.finished args = {}
      request :get, args, :finished
    end

  end
end