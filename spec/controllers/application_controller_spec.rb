require 'spec_helper'


describe ApplicationController do
  
  describe "protected methods" do
    it "#not_found raise RoutingError" do
      expect { @controller.send(:not_found) }.to raise_error ActionController::RoutingError
    end
    
    it "#flash_message creates array of flash" do
      @controller.send(:flash_message, :notice, "haha")
      @controller.send(:flash_message, :notice, "next")
      expect(flash[:notice]).to eq(["haha", "next"])
    end
  end
end