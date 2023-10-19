# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Authors', type: :request do
  describe 'GET /authors' do
    it 'returns a list of authors' do
      create_list(:author, 3)

      get '/authors', headers: { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
      expect(response).to have_http_status(200)
      # expect(response).to match_response_schema("authors")
    end
  end

  describe 'GET /authors/:id (Show)' do
    it 'returns a specific author' do
      author = create(:author)

      get "/authors/#{author.id}", headers: { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
      expect(response).to have_http_status(200)
    end

    it 'returns a 404 status if the author is not found' do
      get '/authors/999', headers: { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
      expect(response).to have_http_status(404)
    end
  end

  describe 'POST /authors' do
    it 'creates a new author' do
      author_params = { first_name: 'Sample author', last_name: 'John Doe', date_of_birth: '1999-02-21' }

      post '/authors', params: { author: author_params }.to_json,
                       headers: { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
      expect(response).to have_http_status(201)
    end
  end

  describe 'PUT /authors/:id (Update)' do
    it 'updates a author' do
      author = create(:author)
      updated_params = { first_name: 'David' }

      put "/authors/#{author.id}", params: { author: updated_params }.to_json,
                                   headers: { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
      expect(response).to have_http_status(200)
      author.reload
      expect(author.first_name).to eq('David')
    end

    it 'returns a 404 status if the author is not found' do
      put '/authors/999', params: { author: { title: 'Updated Title' } }.to_json,
                          headers: { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
      expect(response).to have_http_status(404)
    end
  end

  describe 'DELETE /authors/:id (Delete)' do
    it 'deletes a author' do
      author = create(:author)

      delete "/authors/#{author.id}", headers: { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
      expect(response).to have_http_status(204)
      expect { author.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'returns a 404 status if the author is not found' do
      delete '/authors/999', headers: { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
      expect(response).to have_http_status(404)
    end
  end

  describe 'GET #list_books' do
    it 'lists all books from an author' do
      author = create(:author)
      book = create(:book)
      author.books << book

      get "/authors/#{author.id}/books",
          headers: { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }

      JSON.parse(response.body)
      expect(response).to have_http_status(:ok)
      # expect(response_data).to include(book.to_json(only: [:id, :name, :synopsis, :release_date, :edition, :price]))
    end
  end

  describe 'POST #add_book' do
    it 'adds a book to an author' do
      author = create(:author)
      book = create(:book)

      post "/authors/#{author.id}/add_book/#{book.id}",
           headers: { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
      expect(response).to have_http_status(:ok)
      author.reload
      expect(author.books).to include(book)
    end

    it 'returns an error if book is already associated with the author' do
      author = create(:author)
      book = create(:book)

      author.books << book
      post "/authors/#{author.id}/add_book/#{book.id}",
           headers: { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
      expect(response).to have_http_status(:unprocessable_entity)
      response_data = JSON.parse(response.body)
      expect(response_data['error']).to include('Author has already been taken')
    end
  end

  describe 'DELETE #remove_book' do
    it 'removes a book from an author' do
      author = create(:author)
      book = create(:book)

      author.books << book
      delete "/authors/#{author.id}/remove_book/#{book.id}",
             headers: { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
      expect(response).to have_http_status(:no_content)
      author.reload
      expect(author.books).not_to include(book)
    end

    it 'returns an error if the book is not associated with the author' do
      author = create(:author)
      book = create(:book)

      delete "/authors/#{author.id}/remove_book/#{book.id}",
             headers: { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
      expect(response).to have_http_status(:unprocessable_entity)
      response_data = JSON.parse(response.body)
      expect(response_data['error']).to include('not associated')
    end
  end
end
