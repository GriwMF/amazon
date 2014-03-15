module ActiveRecordGroupCount
  module Scope
    extend ActiveSupport::Concern

    module ExtensionMethods
      def count(*args)
        scope = except(:select).select("1")
        query = "SELECT count(*) AS count_all FROM (#{scope.to_sql}) x"
        ActiveRecord::Base.connection.execute(query).first.try(:[], "count_all").to_i
      end
    end

    module ClassMethods
      def returns_count_sum
        all.extending(ExtensionMethods)
      end
    end
  end
  
  ActiveSupport.on_load :active_record do
    include ActiveRecordGroupCount::Scope
  end
end
