class AboutController < ApplicationController

  def email_params
    params{[:email_address => email_address, :message => message]}
  end

  def send_email
    ContactUsMailer.send_email(email_params)
    redirect_to :back
  end

end