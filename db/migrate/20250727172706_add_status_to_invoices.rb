class AddStatusToInvoices < ActiveRecord::Migration[8.0]
  def change
    add_column :invoices, :status, :string
  end
end
