require Rails.root.join('lib/sendgrid_mailer')

ActionMailer::Base.add_delivery_method :sendgrid_mailer, SendgridMailer