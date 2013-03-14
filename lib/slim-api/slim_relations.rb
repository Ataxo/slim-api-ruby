# -*- encoding : utf-8 -*-

#FIX inflections!
ActiveSupport::Inflector.inflections do |inflect|
  inflect.uncountable "statistics"
end

module SlimApi
  module SlimRelations

    def belongs_to name, foreign_key
      variable_name = "@_#{name}"
      loaded_variable_name = "@_#{name}_loaded"
      local_variable_name = "#{name}"
      klass_name = "#{name}".singularize.camelize
      self.class_eval <<DEF
        def #{name}
          if #{name}_loaded?
            #{variable_name}
          elsif #{local_variable_name} = #{klass_name}.find(self[:#{foreign_key}])
            #{loaded_variable_name} = true
            #{variable_name} = #{local_variable_name}
          else
            #{loaded_variable_name} = true
            nil
          end
        end

        def #{name}_loaded?
          !!#{loaded_variable_name}
        end

        def #{name}_empty?
          !#{name}_loaded? || #{variable_name}.nil?
        end
DEF
    end

     def has_many name, foreign_key
      variable_name = "@_#{name}"
      loaded_variable_name = "@_#{name}_loaded"
      klass_name = "#{name}".singularize.camelize
      self.class_eval <<DEF
        def #{name}
          if #{name}_loaded?
            #{variable_name}
          else
            #{loaded_variable_name} = true
            #{variable_name} = #{klass_name}.where(#{foreign_key}: self[self.class::PRIMARY_KEY])
          end
        end

        def #{name}_loaded?
          !!#{loaded_variable_name}
        end

        def #{name}_empty?
          !#{name}_loaded? || #{variable_name}.nil?
        end

        def #{name}_reload
          #{loaded_variable_name} = false
          #{variable_name} = nil
        end
DEF
    end

  end
end
