class ApiController < ApplicationController
  before_action :check_key
  respond_to :json

  def index
    respond_with User.find(1)
  end

  private
    def check_key
      render json: { error: "The provided token wasn't correct" }, status: :bad_request unless ApiApplication.exists?(client_key: request.headers["Authorization"])
    end
end
