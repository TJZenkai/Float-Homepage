class PlaidController < ApplicationController

  before_filter :check_for_mobile

  def bank_login
    @type = request.original_url.split("/")[4]
    if request.post?
      base_uri = ENV['BASE_URI']
      response = HTTParty.post "#{base_uri}/banking/login",
      :body =>
        params.slice(:username, :password, :institution_id, :pin),
      :cookies =>
        {:laravel_session => cookies[:laravel_session]}
      @json_response = JSON.parse(response.body)

      if response.code == 200
        redirect_to float_score_path
        flash[:notice] = nil

      elsif response.code == 201
        redirect_to bank_mfa_path
        if @json_response["mfa"][0]["question"] != nil
          flash[:question] = @json_response["mfa"][0]["question"]
        else
          flash[:message] = @json_response["mfa"][0]["message"]
        end
      else
        flash[:notice] = @json_response["message"]
      end
    end
  end

  # Bank Multi-Factor Authentication
  def mfa
    if request.post?
      base_uri = ENV['BASE_URI']
      response = HTTParty.post "#{base_uri}/banking/login/challenge",
      :body =>
        params.slice(:challenge),
      :cookies =>
        {:laravel_session => cookies[:laravel_session]}
      @json_response = JSON.parse(response.body)

      if response.code == 200
        redirect_to float_score_path
      elsif response.code == 201
        if @json_response["mfa"][0]["question"] != nil
          flash[:question] = @json_response["mfa"][0]["question"]
        else
          flash[:message] = @json_response["mfa"][0]["message"]
        end
      elsif response.code == 402
        flash[:notice] = @json_response["data"]
      else
        flash[:notice] = @json_response["message"]
      end
    end
  end

  # Retrieve Safe to Loan Amount for User
  def float_score
    base_uri = ENV['BASE_URI']
    response = HTTParty.get "#{base_uri}/score/accounts_safe_to_loan",
    :cookies =>
      {:laravel_session => cookies[:laravel_session]}
    @json_response = JSON.parse(response.body)

    if response.code == 200
      @float_score = @json_response["data"]["safe_to_loan"]
    else
      redirect_to institutions_path
    end

  end

  # List Banks from Plaid
  def institutions
    flash[:notice] = nil
    base_uri = ENV['BASE_URI']
    response = JSON.parse HTTParty.get("#{base_uri}/banking/institutions").body
    exclude_banks = ["capone360", "amex", "schwab", "fidelity", "svb", "pnc"]
    @list = response['institutions'].reject{ |i| exclude_banks.include? i['type'] }
  end

end
