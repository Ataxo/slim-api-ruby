# -*- encoding : utf-8 -*-

module SlimApi
  class SlimArray < Array

    attr_accessor :total_count, :limit, :offset, :find_options, :find_object

    def next_page_offset
      @offset + @limit
    end

    def has_next_page?
      next_page_offset < @total_count
    end

    def next_page
      if has_next_page?
        find_object.find @find_options.merge(:limit => @limit, :offset => next_page_offset)
      else
        nil
      end
    end

    def all
      all_objects = []
      self_object = self
      while self_object do
        all_objects += self_object
        self_object = self_object.next_page
      end
      all_objects
    end

    def page_count
      (@total_count.to_f/@limit.to_f).ceil
    end

    def actual_page
      (@offset.to_f/@limit.to_f).ceil+1
    end

    def page_range
      max = @offset+@limit-1
      max = @total_count-1 if @total_count < max
      (@offset..max)
    end
  end
end