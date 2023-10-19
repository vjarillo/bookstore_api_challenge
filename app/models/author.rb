# frozen_string_literal: true

class Author < ApplicationRecord
  validates_presence_of :first_name, :last_name, :date_of_birth
  validates_uniqueness_of :first_name, :last_name

  has_many :published_books, dependent: :destroy
  has_many :books, through: :published_books
end
