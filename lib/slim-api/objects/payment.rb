# -*- encoding : utf-8 -*-

module SlimApi
  class Payment

    include SlimObject

    NAME = :payment
    PRIMARY_KEY = :id

    has_many :contracts, :campaign_id
    has_many :campaigns, :campaign_id

  end
end