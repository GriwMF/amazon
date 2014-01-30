require 'spec_helper'

describe RatingsController do
  before do
    allow(controller).to receive(:check_admin) { false }
  end

  describe "GET 'check_ratings'" do
    it "assigns unrated books" do
      rating = FactoryGirl.create :rating, approved: nil
      get 'check_ratings'
      assigns(:book_ratings).should eq([rating])
    end
  end

end
