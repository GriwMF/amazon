class RatingsController < ApplicationController
  include Concerns::SessionManagement
  before_action :set_rating, except: [:check_ratings]
  
  
  def check_ratings
    check_admin and return
    @book_ratings = Rating.where(approved: nil)
  end
  
  def approve
    check_admin and return
    @book_rating.approved = true
    @book_rating.save
    redirect_to ratings_check_ratings_path
  end
  
  def destroy
    check_admin and return
    @book_rating.destroy
    redirect_to ratings_check_ratings_path
  end
  
  private
  
  def set_rating
    @book_rating = Rating.find(params[:id])
  end
end
