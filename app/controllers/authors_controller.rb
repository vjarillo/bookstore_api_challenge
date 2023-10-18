# frozen_string_literal: true

class AuthorsController < ApplicationController
  before_action :find_author, only: %i[show update destroy]

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

  private

  def author_params
    params.require(:author).permit(:first_name, :last_name, :date_of_birth)
  end

  def find_author
    @author = Author.find(params[:id])
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: e.message }, status: :not_found
  end
end
