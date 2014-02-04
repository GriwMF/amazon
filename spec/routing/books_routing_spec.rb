require "spec_helper"

describe BooksController do
  describe "routing" do

    it "routes to #index" do
      get("/books").should route_to("books#index")
    end

    it "routes to #new" do
      get("/books/new").should route_to("books#new")
    end

    it "routes to #show" do
      get("/books/1").should route_to("books#show", :id => "1")
    end

    it "routes to #edit" do
      get("/books/1/edit").should route_to("books#edit", :id => "1")
    end

    it "routes to #create" do
      post("/books").should route_to("books#create")
    end

    it "routes to #update" do
      put("/books/1").should route_to("books#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/books/1").should route_to("books#destroy", :id => "1")
    end
    
    it "routes to #un_author" do
      delete("/books/1/author/1").should route_to("books#un_author", :author_id => "1", :id => "1")
    end
    
    it "routes to #un_category" do
      delete("/books/1/category/1").should route_to("books#un_category", :category_id => "1", :id => "1")
    end
    
    it "routes to #wished" do
      delete("/books/1/wished").should route_to("books#wished", :id => "1")
    end    
     
    it "routes to #assign_author" do
      post("/books/1/assign_author").should route_to("books#assign_author", :id => "1")
    end    
    
    it "routes to #assign_category" do
      post("/books/1/assign_category").should route_to("books#assign_category", :id => "1")
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
