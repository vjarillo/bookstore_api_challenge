# frozen_string_literal: true

class PublishedBook < ApplicationRecord
  belongs_to :author
  belongs_to :book
end
