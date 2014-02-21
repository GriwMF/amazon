require "spec_helper"
require "cancan/matchers"

describe "Customer" do
  describe "abilities" do
    subject(:ability){ Ability.new(customer) }
    let(:customer){ nil }

    context "when is an unauthorized customer" do
      it{ should be_able_to(:read, Book.new) }
      it{ should be_able_to(:home, Book.new) }
      it{ should_not be_able_to(:manage, :all) }
      it{ should_not be_able_to(:access, :rails_admin) }
    end

    context "when is a regular customer" do
      let(:customer){ FactoryGirl.create :customer }
      it{ should be_able_to(:home, Book.new) }
      it{ should be_able_to(:read, :all) }
      it{ should be_able_to(:manage, Address.new) }
      it{ should be_able_to(:manage, CreditCard.new) }
      it{ should be_able_to(:manage, Customer.new) }
      it{ should be_able_to(:rate, Book.new) }
      it{ should be_able_to(:add_wished, Book.new) }
      it{ should be_able_to(:wished, Book.new) }
      it{ should be_able_to(:filter, Book.new) }
      
      
      it{ should be_able_to(:update, Order.new) }
      it{ should be_able_to(:add_item, Order.new) }
      it{ should be_able_to(:remove_item, Order.new) }
      it{ should be_able_to(:recent, Order.new) }
      
      it{ should_not be_able_to(:manage, :all) }
      it{ should_not be_able_to(:access, :rails_admin) }
    end    
    
    context "when is a administrator" do
      let(:customer){ FactoryGirl.create :admin_customer }
      
      it{ should be_able_to(:manage, :all) }
      it{ should be_able_to(:access, :rails_admin) }
    end    
  end
end
