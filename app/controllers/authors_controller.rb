# frozen_string_literal: true

class AuthorsController < ApplicationController
  before_action :find_author, only: %i[show update destroy list_books add_book remove_book]
  before_action :find_book, only: %i[add_book remove_book remove_book]

  def index
    render 'authors/index', locals: { authors: Author.all }
  end

  def show
    render 'authors/show', locals: { author: @author }
  end

  def create
    @author = Author.new(author_params)

    if @author.save
      render 'authors/show', locals: { author: @author }, status: :created
    else
      render 'shared/errors', locals: { error_object: @author }, status: :unprocessable_entity
    end
  end

  def update
    if @author.update(author_params)
      render 'authors/show', locals: { author: @author }, status: :ok
    else
      render 'shared/errors', locals: { error_object: @author }, status: :unprocessable_entity
    end
  end

  def destroy
    @author.destroy

    head(:no_content)
  end

  def list_books
    render 'books/index', locals: { books: @author.books }
  end

  def add_book
    @author.books << @book
    render json: { message: 'Book added to author successfully' }, status: :ok
  rescue ActiveRecord::RecordInvalid => e
    render 'shared/errors', locals: { error_object: e.record }, status: :unprocessable_entity
  end

  def remove_book
    render json: { error: 'Book not associated' }, status: :unprocessable_entity unless @author.books.include?(@book)

    @author.books.delete(@book)
  end

  private

  def author_params
    params.require(:author).permit(:first_name, :last_name, :date_of_birth)
  end

  def find_author
    @author = Author.find(params[:id])
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: e.message }, status: :not_found
  end

  def find_book
    @book = Book.find(params[:book_id])
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: e.message }, status: :not_found
  end
end
