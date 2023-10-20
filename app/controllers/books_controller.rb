# frozen_string_literal: true

class BooksController < ApplicationController
  before_action :authenticate_user!, except: %i[index show find_book]
  before_action :find_book, only: %i[show update destroy]

  def index
    render 'books/index', locals: { books: Book.all }
  end

  def show
    render 'books/show', locals: { book: @book }
  end

  def create
    @book = Book.new(book_params)

    if @book.save
      render 'books/show', locals: { book: @book }, status: :created
    else
      render 'shared/errors', locals: { error_object: @book }, status: :unprocessable_entity
    end
  end

  def update
    if @book.update(book_params)
      render 'books/show', locals: { book: @book }, status: :ok
    else
      render 'shared/errors', locals: { error_object: @book }, status: :unprocessable_entity
    end
  end

  def destroy
    @book.destroy

    head(:no_content)
  end

  private

  def book_params
    params.require(:book).permit(:name, :synopsis, :release_date, :edition, :price)
  end

  def find_book
    @book = Book.find(params[:id])
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: e.message }, status: :not_found
  end
end
