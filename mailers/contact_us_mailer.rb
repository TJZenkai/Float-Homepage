class ContactUsMailer < ApplicationMailer
  default from: ENV["FLOAT_EMAIL_USERNAME"]
  default to: ENV["FLOAT_EMAIL_USERNAME"]

  def params
    params{[:email_address => email_address, :message => message]}
  end


  def send_email (params)
    @email_address = params[:email_address]
    @message = params[:message]
    mail(to: ENV["FLOAT_EMAIL_USERNAME"], subject: 'Inquiry from about page!', from: ENV["FLOAT_EMAIL_USERNAME"]).deliver!
  end
end
