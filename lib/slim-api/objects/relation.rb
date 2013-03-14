# -*- encoding : utf-8 -*-

module SlimApi
  class Relation

    include SlimObject

    NAME = :relation
    PRIMARY_KEY = :id

    has_many :contracts, :campaign_id
    has_many :campaigns, :campaign_id

  end
end