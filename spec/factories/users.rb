# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { 'tamarindo@email.com' }
    password { 'password' }
    jti { '99999-2b79-4bf6-921a-bb7f6466d239' }
  end
end
