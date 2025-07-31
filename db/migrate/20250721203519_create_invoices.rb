class CreateInvoices < ActiveRecord::Migration[8.0]
  def change
    create_table :invoices do |t|
      t.date :due_date
      t.decimal :total_amount
      t.references :project, null: false, foreign_key: true

      t.timestamps
    end
  end
end
