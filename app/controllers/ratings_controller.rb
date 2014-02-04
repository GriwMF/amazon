class RatingsController < ApplicationController
  authorize_resource
  load_resource except: :check_ratings, instance_name: :book_rating
  
  def check_ratings
    @book_ratings = Rating.where(approved: nil)
  end
  
  def approve
    @book_rating.approved = true
    @book_rating.save
    redirect_to ratings_check_ratings_path
  end
  
  def destroy
    @book_rating.destroy
    redirect_to ratings_check_ratings_path
  end

end
