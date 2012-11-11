# -*- encoding : utf-8 -*-

module SlimApi
  class Campaign < Hashr
    
    include SlimObject

    NAME = :campaign

    def stats args = {}
      Statistics.find(args.merge(campaign_id: self[:id]))
    end

  end
end