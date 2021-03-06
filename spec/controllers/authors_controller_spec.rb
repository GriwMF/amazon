require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe AuthorsController do
  include Devise::TestHelpers
  
  let(:customer) { FactoryGirl.create :customer }
  
  # This should return the minimal set of attributes required to create a valid
  # Author. As you add validations to Author, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { { "firstname" => "MyString",  "lastname" => "MyString"} }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # AuthorsController. Be sure to keep this updated too.
  let(:valid_session) { {} }
  
  before do
    sign_in customer
  end

  describe "GET show" do
    it "assigns the requested author as @author" do
      author = Author.create! valid_attributes
      get :show, {:id => author.to_param}, valid_session
      assigns(:author).should eq(author)
    end

    it 'redirect to root if havent read ability' do
      ability = Object.new.extend(CanCan::Ability)
      ability.cannot :read, Author
      allow_any_instance_of(CanCan::ControllerResource).to receive(:load_resource)
      allow(@controller).to receive(:current_ability).and_return(ability)
      get :show, {:id => '1'}, valid_session
      response.should redirect_to(root_url)
    end
  end
end
