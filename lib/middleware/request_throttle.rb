# frozen_string_literal: true

module Middleware
  class RequestThrottle
    def initialize(app)
      @app = app
      @request_store = {}
    end

    def call(env)
      ip = env['REMOTE_ADDR']
      current_time = Time.now

      @allowed_requests ||= Rails.application.credentials.fetch(:requests_per_second, 20)

      if requests_from_ip(ip, current_time) >= @allowed_requests
        [429, { 'Content-Type' => 'application/json' }, [{ message: 'Rate Limit Exceded' }.to_json]]
      else
        record_request(ip, current_time)
        status, headers, response = @app.call(env)
        [status, headers, response]
      end
    end

    private

    def requests_from_ip(ip, current_time)
      @request_store[ip]&.count do |timestamp|
        (current_time - timestamp) <= 10.second
      end.to_i
    end

    def record_request(ip, current_time)
      @request_store[ip] ||= []
      @request_store[ip] << current_time

      @request_store[ip].delete_if { |timestamp| (current_time - timestamp) > 40.seconds }
    end
  end
end
