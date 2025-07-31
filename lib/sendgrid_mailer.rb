require 'sendgrid-ruby'

class SendgridMailer
  include SendGrid

  def initialize(values)
    @mail = values[:mail]
  end

  def deliver!(mail = nil)
    mail ||= @mail

    from = Email.new(email: mail.from.first)
    to = Email.new(email: mail.to.first)
    subject = mail.subject
    content = Content.new(type: 'text/plain', value: mail.body.raw_source)

    mail_data = Mail.new(from, subject, to, content)

    sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
    response = sg.client.mail._('send').post(request_body: mail_data.to_json)

    unless response.status_code.start_with?('2')
      raise "SendGrid API Error: #{response.status_code} #{response.body}"
    end

    response
  end
end