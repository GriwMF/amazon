require "spec_helper"

describe BooksController do
  describe "routing" do

    it "routes to #index" do
      get("/books").should route_to("books#index")
    end

    it "routes to #show" do
      get("/books/1").should route_to("books#show", :id => "1")
    end

    it "routes to #home" do
      get("/books/home").should route_to("books#home")
    end
    
    it "routes to #wished" do
      delete("/books/1/wished").should route_to("books#wished", :id => "1")
    end    
     
    it "routes to #rate" do
      post("/books/1/rate").should route_to("books#rate", :id => "1")
    end 
    
    it "routes to #add_wished" do
      patch("/books/1/add_wished").should route_to("books#add_wished", :id => "1")
    end 
    
    it "routes to #filter" do
      post("/books/filter").should route_to("books#filter")
    end
 
  end
end
