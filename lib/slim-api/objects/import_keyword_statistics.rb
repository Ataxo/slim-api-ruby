# -*- encoding : utf-8 -*-

module SlimApi
  class ImportKeywordStatistics < Hashr
    
    include SlimObject

    NAME = :import_keyword_statistics

    def self.finished args = {}
      request :get, args, :finished
    end

  end
end