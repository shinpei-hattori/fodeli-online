class ApplicationMailer < ActionMailer::Base
  if Rails.env == "development"
    default from: 'fodelionline@gmail.com'
  elsif Rails.env == "production"
    default from: 'noreply@fodelionline.site'
  end

  layout 'mailer'
end
