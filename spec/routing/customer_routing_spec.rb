require "spec_helper"

describe CustomersController do
  describe "routing" do

    it "routes to #show" do
      get("/customer").should route_to("customers#show")
    end

    it "routes to #edit" do
      get("/customer/edit").should route_to("customers#edit")
    end

    it "routes to #update" do
      put("/customer").should route_to("customers#update")
    end

  end
end
