module RedHillConsulting::ForeignKeyMigrations::ActiveRecord
  module Base
    def self.included(base)
      base.class_eval do
        base.extend(ClassMethods)
      end
    end

    module ClassMethods
      def references_table_name(table_name, column_name, options)
        column_name = column_name.to_s
        if options.has_key?(:references)
          options[:references]
        elsif column_name == 'parent_id'
          table_name
        elsif column_name =~ /^(.*)_id$/
          pluralized_table_name($1)
        end
      end
    end
  end
end
