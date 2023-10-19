# frozen_string_literal: true

require 'rack/test'
require 'rails_helper'
require_relative '../../lib/middleware/request_throttle'

describe 'RequestThrottle Middleware' do
  include Rack::Test::Methods

  def app
    Middleware::RequestThrottle.new(Rails.application)
  end

  it 'allows requests below the rate limit' do
    10.times do
      get '/home', {}, 'REMOTE_ADDR' => '192.168.1.1'
      expect(last_response.status).to eq(200)
    end
  end

  it 'blocks requests that exceed the rate limit' do
    21.times do
      get '/home', {}, 'REMOTE_ADDR' => '192.168.1.1'
    end

    parsed_response = JSON.parse(last_response.body)

    expect(last_response.status).to eq(429)
    expect(parsed_response['message']).to eq('Rate Limit Exceded')
  end

  it 'resets the rate limit after 50 seconds' do
    21.times do
      get '/home', {}, 'REMOTE_ADDR' => '192.168.1.1'
    end

    parsed_response = JSON.parse(last_response.body)
    expect(last_response.status).to eq(429)
    expect(parsed_response['message']).to eq('Rate Limit Exceded')

    sleep(50.seconds)

    get '/home', {}, 'REMOTE_ADDR' => '192.168.1.1'
    expect(last_response.status).to eq(200)
  end
end
