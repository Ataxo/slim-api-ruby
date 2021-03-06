# -*- encoding : utf-8 -*-

module SlimApi
  class Campaign

    include SlimObject

    NAME = :campaign
    PRIMARY_KEY = :id

    belongs_to :client,   :client_id
    belongs_to :contract, :id
    belongs_to :category, :category_id
    belongs_to :user,     :admin_id

    has_many :statistics, :campaign_id
    alias :stats :statistics
    has_many :payments,   :campaign_id
    has_many :relations,  :campaign_id

  end
end