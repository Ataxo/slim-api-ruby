# -*- encoding : utf-8 -*-

module SlimApi
  class User

    include SlimObject

    NAME = :user
    PRIMARY_KEY = :id

    has_many :contracts, :admin_id
    has_many :campaigns, :admin_id

  end
end