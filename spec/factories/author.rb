# frozen_string_literal: true

FactoryBot.define do
  factory :author do
    first_name { FFaker::Name.first_name }
    last_name { FFaker::Name.last_name }
    date_of_birth { FFaker::Time.date(min_date: Date.new(1980, 1, 1), max_date: Date.today) }
  end
end
