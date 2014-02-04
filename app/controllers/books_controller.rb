class BooksController < ApplicationController
  before_filter :authenticate_customer!, except: [:index, :show]
  
  # before_action :set_book, only: [:show, :edit, :update, :destroy, 
                                  # :un_author, :assign_author, :un_category, :assign_category,
                                  # :rate, :add_wished, :wished]
                                  
  load_and_authorize_resource
  skip_load_resource only: [:index, :filter, :create]

  # GET /books
  # GET /books.json
  def index
    @books = Book.all.includes(:ratings)
  end

  # GET /books/1
  # GET /books/1.json
  def show
    @book_ratings = @book.ratings.where(approved: true).last(10)
  end

  # GET /books/new
  def new
  end

  # GET /books/1/edit
  def edit
  end

  # POST /books
  # POST /books.json
  def create
    new_author
    new_category
    
    @book = Book.new(book_params)
    respond_to do |format|
      if @book.save
        format.html { redirect_to @book, notice: 'Book was successfully created.' }
        format.json { render action: 'show', status: :created, location: @book }
      else
        format.html { render action: 'new' }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /books/1
  # PATCH/PUT /books/1.json
  def update
    respond_to do |format|
      if @book.update(book_params)
        format.html { redirect_to @book, notice: 'Book was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /books/1
  # DELETE /books/1.json
  def destroy
    @book.destroy
    respond_to do |format|
      format.html { redirect_to books_url }
      format.json { head :no_content }
    end
  end

  # DELETE /books/1/author/1
  def un_author
    author = Author.find(params[:author_id])
    @book.authors.delete(author)
    redirect_to edit_book_path(@book)
  end
  
  # POST /books/1/assign_author
  def assign_author
    new_author
    redirect_to edit_book_path(@book)
  end
  
  # DELETE /books/1/category/1
  def un_category
    category = Category.find(params[:category_id])
    @book.categories.delete(category)
    redirect_to edit_book_path(@book)
  end
  
  # POST /books/1/assign_category
  def assign_category
    new_category
    redirect_to edit_book_path(@book)
  end
  
  # POST /books/1/rate
  def rate
    rating = @book.ratings.build(params.permit(:text, :rating))
    rating.customer = current_customer
    if rating.save
      flash[:info] = "Success! Please, wait for rating confirmation"
    else
      flash[:danger] = rating.errors
    end
    redirect_to root_path
  end
  
  # POST /books/1/add_wished
  def add_wished
    unless @book.wish_add(current_customer)
      flash[:danger] = "Already rated"
    else
      flash[:info] = "Successefully added"
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
    redirect_to root_path and return if params[:commit] == "Reset"
    
    @books = Book.filter(*prepare_filter).includes(:ratings)
    render "index"
  end
  
  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def book_params
      params.require(:book).permit(:title, :descirption, :price, :in_stock)
    end
    
    def new_author
      if params[:authors] && (id = params[:authors][:id]) != ""
        @book.authors << Author.find(id)
      else
        flash_message :warning, "Please, select author"
      end
    end
    
    def new_category
      if params[:categories] && (id = params[:categories][:id]) != ""
        @book.categories << Category.find(id)
      else
        flash_message :warning, "Please, select category"
      end
    end
    
    def prepare_filter
      filter_opts = params[:authors_id], params[:categories_id], params[:books_id]
      filter_opts.each { |item| item.shift }
      filter_opts
    end
end
