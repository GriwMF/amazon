require 'spec_helper'

  
describe RatingsController do
  include Devise::TestHelpers

  let(:customer) { FactoryGirl.create :admin_customer }
  
  before do
    sign_in customer
  end

  describe "GET 'check_ratings'" do
    it "assigns unrated books" do
      rating = FactoryGirl.create :rating, approved: nil
      get 'check_ratings'
      assigns(:book_ratings).should eq([rating])
    end
  end

  describe "PATCH 'approve'" do
    it "change rating to approved" do
      rating = FactoryGirl.create :rating, approved: nil
      patch 'approve', {:id => rating.to_param}
      expect(Rating.find(rating).approved).to be_true
    end
    
    it "redirects to check ratings path" do
      rating = FactoryGirl.create :rating, approved: nil
      patch 'approve', {:id => rating.to_param}
      expect(request).to redirect_to ratings_check_ratings_path      
    end    
  end
  
  describe "DELETE 'destroy'" do
    it "change rating to approved" do
      rating = FactoryGirl.create :rating
      delete 'destroy', {:id => rating.to_param}
      expect(Rating.where(:id => rating.id)).to match_array []
    end
    
    it "redirects to check ratings path" do
      rating = FactoryGirl.create :rating
      delete 'destroy', {:id => rating.to_param}
      expect(request).to redirect_to ratings_check_ratings_path      
    end
  end  
end
