require 'spec_helper'

describe Book do
  let(:book) { FactoryGirl.create :book }
  
  it "validates presence of title" do
    expect(book).to validate_presence_of(:title)
  end
 
  it "validates presence of in_stock" do
    expect(book).to validate_presence_of(:in_stock)
  end
  
  it "validates that in_stock is integer >= 0" do
    expect(book).to validate_numericality_of(:in_stock).only_integer
    expect(book).to validate_numericality_of(:in_stock).is_greater_than_or_equal_to(0)
  end    
  
  it "has and belongs to many categories" do
    expect(book).to have_and_belong_to_many(:categories)
  end
  
  it "has and belongs to many authors" do
    expect(book).to have_and_belong_to_many(:authors)
  end  

  it "has and belongs to many wished_customers" do
    expect(book).to have_and_belong_to_many(:wished_customers)
  end  
  
  it "has many order_items" do
    expect(book).to have_many(:order_items)
  end  

  it "has many ratings" do
    expect(book).to have_many(:ratings)
  end

  context "top scope" do
    it "includes 5 books with bigest rating" do
      FactoryGirl.create :rating, state: 'approved', book: book
      expect(Book.top).to include book      
    end

    it "does not include more than 5 books" do
      5.times do
        tmp_book = FactoryGirl.create :book
        FactoryGirl.create :rating, state: 'approved', book: tmp_book, rating: 4
      end
      FactoryGirl.create :rating, state: 'approved', book: book, rating: 3
      expect(Book.top).to_not include book
    end
    
    it "excludes books without rating" do
      expect(Book.top).to_not include book      
    end
  end
  describe "book's methods" do
    let(:customer1) { FactoryGirl.create :customer }
    let(:customer2) { FactoryGirl.create :customer }
    let(:customer3) { FactoryGirl.create :customer }
    
    before do
      book.wished_customers << customer1
      book.wished_customers << customer2
    end
    
    context "#wished" do
      it "returns number of customers who wished the book" do
        expect(book.wished).to eq(2)
      end
    end

    context "#wished_by?" do
      it "returns true if customer wish book" do
        expect(book.wished_by? customer1).to eq(true)
      end

      it "returns false if customer does not wish book" do
        expect(book.wished_by? customer3).to eq(false)
      end      
    end
    
    context "#wish_add" do
      it "add book to customer wishes" do
        expect { book.wish_add customer3 }.to change { book.wished }.by(1)
      end

      it "do nothing if customer already wished the book" do
        expect { book.wish_add customer2 }.to change { book.wished }.by(0)
      end      
    end
    
    describe "rating" do
      before do
        book.ratings.create(text: Faker::Name.title, rating: 5, customer_id: customer1.id, state: 'approved')
        book.ratings.create(text: Faker::Name.title, rating: 1, customer_id: customer2.id, state: 'approved')
      end

      context "#rating" do
        it "counts average book rating (approved only)" do
          expect(book.rating).to eq(3)
        end
      end
          
      context "#unrated?" do
        it "returns false if book is rated by customer" do
          expect(book.unrated? customer1).to eq(false)
        end
        
        it "returns true if book isn't rated by customer" do
          expect(book.unrated? customer3).to eq(true)
        end
      end  
    end      
  end
end
