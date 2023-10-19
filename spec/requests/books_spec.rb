# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Books API', type: :request do
  describe 'GET /books' do
    it 'returns a list of books' do
      create_list(:book, 3)

      get '/books', headers: { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /books/:id' do
    it 'returns a specific book' do
      book = create(:book)

      get "/books/#{book.id}", headers: { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
      expect(response).to have_http_status(200)
    end

    it 'returns a 404 status if the book is not found' do
      get '/books/1234', headers: { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
      expect(response).to have_http_status(404)
    end
  end

  describe 'POST /books' do
    it 'creates a new book' do
      book_params = { name: 'Sample book', synopsis: 'John Doe', release_date: '1999-02-21', edition: 2, price: 2000 }

      post '/books', params: { book: book_params }.to_json,
                     headers: { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
      expect(response).to have_http_status(201)
    end
  end

  describe 'PUT /books/:id' do
    it 'updates a book' do
      book = create(:book)
      updated_params = { edition: 2 }

      put "/books/#{book.id}", params: { book: updated_params }.to_json,
                               headers: { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
      expect(response).to have_http_status(200)
      book.reload
      expect(book.edition).to eq(2)
    end

    it 'returns a 404 status if the book is not found' do
      put '/books/999', params: { book: { edition: 3 } }.to_json,
                        headers: { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
      expect(response).to have_http_status(404)
    end
  end

  describe 'DELETE /books/:id' do
    it 'deletes a book' do
      book = create(:book)

      delete "/books/#{book.id}", headers: { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
      expect(response).to have_http_status(204)
      expect { book.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'returns a 404 status if the book is not found' do
      delete '/books/1234', headers: { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
      expect(response).to have_http_status(404)
    end
  end
end
