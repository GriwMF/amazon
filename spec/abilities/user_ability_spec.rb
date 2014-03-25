require "spec_helper"
require "cancan/matchers"

describe "Customer" do
  describe "abilities" do
    subject(:ability){ Ability.new(customer) }
    let(:customer){ nil }

    shared_examples 'user' do
      it{ should be_able_to(:read, Book.new) }
      it{ should be_able_to(:read, :all) }
      it{ should be_able_to(:add_item, Order.new) }
      it{ should be_able_to(:remove_item, Order.new) }
      it{ should be_able_to(:cart, Order.new) }
      it{ should be_able_to(:update, Order.new) }

      it{ should_not be_able_to(:manage, :all) }
      it{ should_not be_able_to(:access, :rails_admin) }
    end

    context "when is an unauthorized customer" do
      it_behaves_like 'user'
    end

    context "when is a regular customer" do
      let(:customer){ FactoryGirl.create :customer }

      it_behaves_like 'user'

      it{ should be_able_to(:manage, Address.new) }
      it{ should be_able_to(:manage, CreditCard.new) }
      it{ should be_able_to(:manage, Customer.new) }
      it{ should be_able_to(:rate, Book.new) }
      it{ should be_able_to(:add_wished, Book.new) }
      it{ should be_able_to(:wished, Book.new) }
      it{ should be_able_to(:destroy, Order.new) }
      it{ should be_able_to(:check_out, Order.new) }
      it{ should be_able_to(:addresses, Order.new) }
      it{ should be_able_to(:delivery, Order.new) }
      it{ should be_able_to(:credit_card, Order.new) }
      it{ should be_able_to(:complete, Order.new) }

      it{ should be_able_to(:update, Order.new) }
      it{ should be_able_to(:recent, Order.new) }
    end
    
    context "when is a administrator" do
      let(:customer){ FactoryGirl.create :admin_customer }
      
      it{ should be_able_to(:manage, :all) }
      it{ should be_able_to(:access, :rails_admin) }
    end    
  end
end
