class ApplicationController < ActionController::API
  before_action :set_default_response_format

  def set_default_response_format
    request.format = :json
  end
end
