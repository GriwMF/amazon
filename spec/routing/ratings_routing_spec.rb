require "spec_helper"

describe RatingsController do
  describe "routing" do

    it "routes to #check_ratings" do
      get("/ratings/check_ratings").should route_to("ratings#check_ratings")
    end

    it "routes to #approve" do
      patch("/ratings/approve/1").should route_to("ratings#approve", :id => "1")
    end

    it "routes to #destroy" do
      delete("/ratings/decline/1").should route_to("ratings#destroy", :id => "1")
    end

  end
end
