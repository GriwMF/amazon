class BooksController < ApplicationController
  include Concerns::SessionManagement
    
  before_action :set_book, only: [:show, :edit, :update, :destroy, 
                                  :un_author, :assign_author, :un_category, :assign_category,
                                  :rate, :add_wished, :wished]

  # GET /books
  # GET /books.json
  def index
    @books = Book.all.includes(:ratings)
    # session["customer_return_to"] = books_path
  end

  # GET /books/1
  # GET /books/1.json
  def show
    # check_admin and return
    @book_ratings = @book.ratings.where(approved: true).last(10)
  end

  # GET /books/new
  def new
    check_admin and return
    @book = Book.new
  end

  # GET /books/1/edit
  def edit
    check_admin
  end

  # POST /books
  # POST /books.json
  def create
    check_admin and return
    @book = Book.new(book_params)
    new_author
    new_category
    
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
    check_admin and return
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
    check_admin and return
    @book.destroy
    respond_to do |format|
      format.html { redirect_to books_url }
      format.json { head :no_content }
    end
  end

  # DELETE /books/1/author/1
  def un_author
    check_admin and return
    author = Author.find(params[:author_id])
    @book.authors.delete(author)
    redirect_to edit_book_path(@book)
  end
  
  # POST /books/1/assign_author
  def assign_author
    check_admin and return
    new_author
    redirect_to edit_book_path(@book)
  end
  
  # DELETE /books/1/category/1
  def un_category
    check_admin and return
    category = Category.find(params[:category_id])
    @book.categories.delete(category)
    redirect_to edit_book_path(@book)
  end
  
  # POST /books/1/assign_category
  def assign_category
    check_admin and return
    new_category
    redirect_to edit_book_path(@book)
  end
  
  def rate
    authenticate_customer!
    rating = @book.ratings.build(params.permit(:text, :rating))
    rating.customer = current_customer
    if rating.save
      flash[:info] = "Success! Please, wait for rating confirmation"
    else
      flash[:danger] = rating.errors
    end
    redirect_to root_path
  end
  
  def add_wished
    authenticate_customer!
    unless @book.wish_add(current_customer)
      flash[:danger] = "Already rated"
    else
      flash[:info] = "Successefully added"
    end
    redirect_to @book
  end
  
  def wished
    authenticate_customer!
    @book.wished_customers.delete(current_customer)
    redirect_to current_customer
  end
  
  # POST /books/filter
  def filter
    redirect_to root_path and return if params[:commit] == "Reset"
    
    @books = Book.filter(*prepare_filter).includes(:ratings)
    render "index"
  end
  
  def filter_author
    @books = Author.find_by(id: params[:authors_filter][:id]).books
    render "index"
  end
  
  def filter_title
    @books = Book.where(title: params[:title])
    render "index" 
  end
  
  def filter_category
    @books = Category.find_by(id: params[:category_id]).books
    render "index"
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book
      @book = Book.find(params[:id])
    end

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
