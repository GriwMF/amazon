class BooksController < ApplicationController
  before_filter :authenticate_customer!, except: [:index, :show, :home]
  
  load_and_authorize_resource
  skip_load_resource only: [:index, :filter, :home]

  after_filter :decorate_book, only: [:home, :index, :filter]

  # GET /books
  # GET /books.json
  def index
    @books = Book.includes(:ratings).page(params[:page]).per(20)
  end

  # GET /books/home
  def home
    @books = Book.top
  end

  # GET /books/1
  # GET /books/1.json
  def show
    @book_ratings = @book.ratings.approved.last(10)
    @book = @book.decorate
  end

  # POST /books/1/rate
  def rate
    rating = @book.ratings.build(params.permit(:text, :rating))
    rating.customer = current_customer
    if rating.save
      flash[:info] = I18n.t 'suc_rating_add'
    else
      flash[:danger] = rating.errors
    end
    redirect_to :back
  end
  
  # POST /books/1/add_wished
  def add_wished
    unless @book.wish_add(current_customer)
      flash[:danger] =  I18n.t 'err_wish_add'
    else
      flash[:info] =  I18n.t 'suc_wish_add'
    end
    redirect_to @book
  end
  
  # DELETE /books/1/wished
  def wished
    @book.wished_customers.delete(current_customer)
    redirect_to current_customer
  end
  
  # POST /books/filter
  def filter
    redirect_to books_path and return if params[:commit] == I18n.t('reset')
    
    @books = Book.filter(*prepare_filter).includes(:ratings).page(params[:page]).per(2)
    render "index"
  end
  
  private
    def prepare_filter
      filter_opts = params[:authors_id], params[:categories_id], params[:books_id]
      filter_opts.each { |item| item.delete_if(&:empty?) }
      filter_opts
    end

    def decorate_book
      @books = @books.decorate
    end
end
