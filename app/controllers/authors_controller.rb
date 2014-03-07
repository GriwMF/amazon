class AuthorsController < ApplicationController
  before_filter :authenticate_customer!
  
  load_and_authorize_resource

  # GET /authors/1
  # GET /authors/1.json
  def show
  end
end
