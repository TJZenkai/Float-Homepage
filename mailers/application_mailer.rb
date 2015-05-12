class ApplicationMailer < ActionMailer::Base
  default from: ENV["FLOAT_EMAIL_USERNAME"]
  layout 'mailer'
end
