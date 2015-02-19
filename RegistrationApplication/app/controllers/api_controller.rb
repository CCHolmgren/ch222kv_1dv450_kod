class ApiController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :check_key

  private
    def check_key
      render json: { error: "The provided token wasn't correct" }, status: :bad_request unless ApiApplication.exists?(client_key: request.headers["Authorization"])
    end
end
