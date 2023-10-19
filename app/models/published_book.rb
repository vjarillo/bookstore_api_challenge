# frozen_string_literal: true

class PublishedBook < ApplicationRecord
  belongs_to :author
  belongs_to :book

  validates :author_id, uniqueness: {
    scope: [:book_id]
  }
end
