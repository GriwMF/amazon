require 'spec_helper'

describe NavigationController do

  describe "GET 'show'" do
    it "assigns categories and authors" do
      category = FactoryGirl.create :category
      author = FactoryGirl.create :author
     
      get :show
      assigns(:authors).should eq([author])
      assigns(:categories).should eq([category])
    end
  end

end
