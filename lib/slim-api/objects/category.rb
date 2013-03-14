# -*- encoding : utf-8 -*-

module SlimApi
  class Category

    include SlimObject

    NAME = :category
    PRIMARY_KEY = :id

    has_many :contracts, :category_id
    has_many :campaigns, :category_id

  end
end