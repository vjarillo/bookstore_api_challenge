# frozen_string_literal: true

class Book < ApplicationRecord
  validates_presence_of :name, :synopsis, :release_date, :edition, :price
  validates_uniqueness_of :name

  has_many :published_books
  has_many :authors, through: :published_books
end
