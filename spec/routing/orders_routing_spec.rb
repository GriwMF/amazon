require "spec_helper"

describe OrdersController do
  describe "routing" do

    it "routes to #index" do
      get("/orders").should route_to("orders#index")
    end

    it "routes to #new" do
      get("/orders/new").should route_to("orders#new")
    end

    it "routes to #show" do
      get("/orders/1").should route_to("orders#show", :id => "1")
    end

    it "routes to #edit" do
      get("/orders/1/edit").should route_to("orders#edit", :id => "1")
    end

    it "routes to #create" do
      post("/orders").should route_to("orders#create")
    end

    it "routes to #update" do
      put("/orders/1").should route_to("orders#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/orders/1").should route_to("orders#destroy", :id => "1")
    end

    it "routes to #add_item" do
      post("/orders/add_item/1").should route_to("orders#add_item", :id => "1")
    end
    
    it "routes to #delete_item" do
      delete("/orders/remove_item/1").should route_to("orders#remove_item", :id => "1")
    end    
    
    it "routes to #check_out" do
      post("/orders/check_out").should route_to("orders#check_out")
    end       
  end
end
