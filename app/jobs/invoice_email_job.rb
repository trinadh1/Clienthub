class InvoiceEmailJob < ApplicationJob
  queue_as :default

  def perform(invoice_id)
    invoice = Invoice.find(invoice_id)
    InvoiceMailer.invoice_email(invoice).deliver_later
    Rails.logger.info "Sending invoice to: #{invoice.project.client.email}"
  end
end