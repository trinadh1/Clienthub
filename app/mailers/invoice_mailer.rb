class InvoiceMailer < ApplicationMailer
  default from: "reddytrinadh730@gmail.com"

  def invoice_email(invoice)
    @invoice = invoice
    @project = invoice.project
    @client = @project.client

    mail(to: @client.email, subject: "New Invoice from #{@project.title}")
  end
end