# frozen_string_literal: true

FactoryBot.define do
  factory :book do
    name { FFaker::Book.title }
    synopsis { FFaker::Book.description }
    release_date { FFaker::Time.date(min_date: Date.new(2000, 1, 1), max_date: Date.today) }
    edition { rand(11) }
    price { rand(600) }
  end
end
