class ApplicationMailer < ActionMailer::Base
  if Rails.env == "production"
    default from: 'noreply@fodelionline.site'
  else
    default from: 'fodelionline@gmail.com'
  end

  layout 'mailer'
end
