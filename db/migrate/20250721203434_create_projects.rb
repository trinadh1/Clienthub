class CreateProjects < ActiveRecord::Migration[8.0]
  def change
    create_table :projects do |t|
      t.string :title
      t.text :description
      t.references :client, null: false, foreign_key: true

      t.timestamps
    end
  end
end
