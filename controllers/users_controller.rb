class UsersController < ApplicationController

  before_filter :check_for_mobile

  def index
  end

  def login
  end

  def authenticate_user
    if request.post?
      base_uri = ENV['BASE_URI']
      response = HTTParty.post "#{base_uri}/users/login",
      :body =>
        params.slice(:email, :password)
      @json_response = JSON.parse(response.body)
      match = response.headers["set-cookie"].match /laravel_session=(?<cookie>[\d\w]+)/i
      cookies[:laravel_session] = match[:cookie]

      if response.code == 200
        redirect_to float_score_path
        flash[:notice] = nil
      elsif response.code == 401
        flash[:notice] = "Username and password do not match."
      else
        redirect_to institutions_path
      end
    end
  end

  def signup
  end

  def create
    if request.post?
      base_uri = ENV['BASE_URI']
      response = HTTParty.post "#{base_uri}/users",
      :body =>
        params.slice(:email, :mobile_phone, :password, :first_name, :last_name, :age, :timezone)
      @json_response = JSON.parse(response.body)
      match = response.headers["set-cookie"].match /laravel_session=(?<cookie>[\d\w]+)/i
      cookies[:laravel_session] = match[:cookie]

      if response.code == 200
        redirect_to institutions_path
      elsif response.code == 201
        flash[:notice] = @json_response["error"]["message"]
      else
        flash[:notice] = @json_response["error"]["message"]
      end
    end
  end

  def get_user_details
    base_uri = ENV['BASE_URI']
    response = HTTParty.get "#{base_uri}/users", :cookies => {:laravel_session => cookies[:laravel_session]}
    @json_response = JSON.parse(response.body)
  end

  def get_user_count
    base_uri = ENV['BASE_URI']
    response = HTTParty.get "#{base_uri}/users/count"
    @json_response = JSON.parse(response.body)
  end

  def logout
    base_uri = ENV['BASE_URI']
    response = HTTParty.get "#{base_uri}/users/logout"
    cookies[:laravel_session] = nil
    flash[:notice] = nil
    redirect_to root_path
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params{[
      :email => email,
      :mobile_phone => mobile_phone,
      :password => password,
      :first_name => first_name,
      :last_name => last_name,
      :age => age,
      :timezone => timezone
    ]}
  end

end
