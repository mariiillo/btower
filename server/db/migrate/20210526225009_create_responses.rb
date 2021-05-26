class CreateResponses < ActiveRecord::Migration[6.1]
  def change
    create_table :responses do |t|
      t.integer :code, null: false
      t.json :headers
      t.string :body
      t.references :endpoint, null: false, foreign_key: true

      t.timestamps
    end
  end
end
