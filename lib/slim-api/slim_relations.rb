# -*- encoding : utf-8 -*-

#FIX inflections!
ActiveSupport::Inflector.inflections do |inflect|
  inflect.uncountable "statistics"
end

module SlimApi
  module SlimRelations

    def belongs_to name, foreign_key
      variable_name = "@_#{name}".to_sym
      local_variable_name = "#{name}"
      klass_name = "#{name}".singularize.camelize
      self.class_eval <<DEF
        def #{name}
          if #{variable_name}
            #{variable_name}
          elsif #{local_variable_name} = #{klass_name}.find(self[:#{foreign_key}])
            #{variable_name} = #{local_variable_name}
          else
            nil
          end
        end
DEF
    end

     def has_many name, foreign_key
      variable_name = "@_#{name}".to_sym
      klass_name = "#{name}".singularize.camelize
      self.class_eval <<DEF
        def #{name}
          #{variable_name} ||= #{klass_name}.where(#{foreign_key}: self[self.class::PRIMARY_KEY])
        end
DEF
    end

  end
end
