class ApiController < ApplicationController
  protect_from_forgery with: :null_session
  OFFSET = 0
  LIMIT = 50
  def offset_params
    #This clamps the offset and limit values between 0 and Infinity, since there isnt a clamp function in ruby
    @offset = [0, params[:offset].to_i, 1.0 / 0].sort[1]
    #This also clamps, between 1 and 50
    @limit = [10, params[:limit].to_i, 100].sort[1]
  end
  private
    def check_key
      if ApiApplication.exists?(client_key: request.headers["Authorization"].split.last)
        ApiApplication.find_by_client_key(request.headers["Authorization"].split.last).user
      else
        render json: { error: "The provided Authroization token wasn't correct. You must provide a valid one that you can get from the api registration page." }, status: :unauthorized
      end
    end
    def authenticate
       @user = authenticate_token || check_key
    end
    def authenticate_token
      p "Inside authenticate_token"
      return unless request.headers["Authorization"].present?
      @token = Token.find_by(value: request.headers["Authorization"].split.last)
      return if @token.nil?
      if @token.expiry >= Time.now
        @token.user
      else
        render json: {message: "Your token has expired. Please generate a new token and try again", status: 401 }, status: :unauthorized
      end
    end
end
