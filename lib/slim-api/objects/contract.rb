# -*- encoding : utf-8 -*-

module SlimApi
  class Contract

    include SlimObject

    NAME = :contract
    PRIMARY_KEY = :id

    belongs_to :client,   :client_id
    belongs_to :campaign, :id
    belongs_to :category, :category_id
    belongs_to :user,     :admin_id

    has_many :statistics, :campaign_id
    alias :stats :statistics
    has_many :payments,   :campaign_id
    has_many :relations,  :campaign_id

  end
end