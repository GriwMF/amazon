module ActiveRecordGroupCount
  ActiveSupport.on_load :active_record do
    include ActiveRecordGroupCount::Scope
  end
end