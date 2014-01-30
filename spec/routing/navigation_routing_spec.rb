require "spec_helper"

describe NavigationController do
  describe "routing" do

    it "routes to #show" do
      get("/navigation/show").should route_to("navigation#show")
    end
    
  end
end
