# frozen_string_literal: true

class Author < ApplicationRecord
  validates_presence_of :name, :synopsis, :release_date, :edition, :price
end
