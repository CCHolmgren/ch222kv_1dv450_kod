class ApiController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :check_key

  private
    def check_key
      render json: { error: "The provided Authroization token wasn't correct. You must provide a valid one that you can get from the api registration page." }, status: :unauthorized unless ApiApplication.exists?(client_key: request.headers["Authorization"])
    end
end
