require "spec_helper"

describe OrdersController do
  describe "routing" do

    it "routes to #index" do
      get("/orders").should route_to("orders#index")
    end
    
    it "routes to #recent" do
      get("/orders/recent").should route_to("orders#recent")
    end

    it "routes to #show" do
      get("/orders/1").should route_to("orders#show", :id => "1")
    end

    it "routes to #cart" do
      get("/orders/cart").should route_to("orders#cart")
    end

    it "routes to #complete" do
      get("/orders/complete").should route_to("orders#complete")
    end

    it "routes to #check_out" do
      get("/orders/check_out/1").should route_to("orders#check_out", :step => "1")
    end

    it "routes to #update" do
      patch("/orders/update").should route_to("orders#update")
    end

    it "routes to #add_item" do
      post("/orders/add_item/1").should route_to("orders#add_item", :id => "1")
    end
    
    it "routes to #remove_item" do
      delete("/orders/remove_item/1").should route_to("orders#remove_item", :id => "1")
    end

    it "routes to #addresses" do
      patch("/orders/addresses").should route_to("orders#addresses")
    end

    it "routes to #delivery" do
      patch("/orders/delivery").should route_to("orders#delivery")
    end

    it "routes to #credit_card" do
      patch("/orders/credit_card").should route_to("orders#credit_card")
    end

    it "routes to #destroy" do
      delete("/orders/destroy").should route_to("orders#destroy")
    end
  end 
end
