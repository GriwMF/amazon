require 'spec_helper'

include Warden::Test::Helpers
Warden.test_mode!

RSpec.configure do |config|
  config.after(:each, :type => :feature) do
    	Warden.test_reset!
  end
end