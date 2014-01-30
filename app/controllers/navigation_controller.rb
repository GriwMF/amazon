class NavigationController < ApplicationController
  def show
    @categories = Category.all
    @authors = Author.all
  end
end
