require "spec_helper"

describe CustomersController do
  describe "routing" do

    it "routes to #show" do
      get("/customer").should route_to("customers#show")
    end
  end
end
