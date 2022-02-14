class ApplicationMailer < ActionMailer::Base
  if Rails.env = "development"
    default from: 'fodelionline@gmail.com'
  else
    default from: 'noreply@fodelionline.site'
  end
  layout 'mailer'
end
