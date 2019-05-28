class ApplicationMailer < ActionMailer::Base
  add_template_helper ProductsHelper
  add_template_helper OrdersHelper

  default from: "noreply@gmail.com"
  layout "mailer"
end
