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
end
