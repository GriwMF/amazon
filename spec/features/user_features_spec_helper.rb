require 'features/features_spec_helper'

RSpec.configure do |config|
  config.before(:each) do
    login_as(FactoryGirl.create(:customer), :scope => :customer)
  end
end