require "spec_helper"

describe AuthorsController do
  describe "routing" do
    it "routes to #show" do
      get("/authors/1").should route_to("authors#show", :id => "1")
    end
  end
end
