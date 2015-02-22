class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user, only: [:edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update, :destroy]
  respond_to :json, :html
  # GET /users
  # GET /users.json
  def index
    #This clamps the offset and limit values between 0 and Event.count-1, since there isnt a clamp function in ruby
    offset = [0, params[:offset].to_i, User.count-1].sort[1]
    #This also clamps, between 1 and 5
    limit = [1, params[:limit].to_i, 5].sort[1]
    #Sort asc since that means start from id 1 and work upwards
    @users = User.all.offset(offset).limit(limit)

    count = @users.count

    #If the offset + limit selects higher items than there is, no next_link
    if offset+limit >= User.count
      next_link = nil
    elsif count < User.count
      next_link = "http://localhost:3000/api/v1/users/?offset=#{offset+limit}&limit=#{limit}"
    else
      next_link = nil
    end
    #If the offset is larger than 0, there must be atleast 1 item before
    if offset > 0 && User.count > 0
      #Do note that offset - limit can become negative, but since offset gets clamped, it doesn't really matter
      previous = "http://localhost:3000/api/v1/users/?offset=#{offset-limit}&limit=#{limit}"
    else
      previous = nil
    end

    respond_with users: @users, total: User.count, limit: limit, offset: offset, next: next_link, previous: previous
  end

  # GET /users/1
  # GET /users/1.json
  def show
    respond_with @user
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    @user.is_administrator = false

    respond_to do |format|
      if @user.save
        format.html { redirect_to login_url, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: login_url }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  def correct_user
    redirect_to :root, notice: "You can't edit that user" unless current_user.is_administrator or current_user?(@user)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:username, :password, :password_confirmation, :email)
  end
end
