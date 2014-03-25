require "spec_helper"

describe CustomersController do
  describe "routing" do

    it "routes to #show" do
      get("/customer").should route_to("customers#show")
    end

    it "routes to #ship_create" do
      post("/customer/ship_update").should route_to("customers#ship_create")
    end

    it "routes to #bill_create" do
      post("/customer/bill_update").should route_to("customers#bill_create")
    end

    it "routes to #ship_update" do
      patch("/customer/ship_update").should route_to("customers#ship_update")
    end

    it "routes to #bill_update" do
      patch("/customer/bill_update").should route_to("customers#bill_update")
    end
  end
end
