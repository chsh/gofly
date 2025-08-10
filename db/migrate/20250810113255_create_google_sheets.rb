class CreateGoogleSheets < ActiveRecord::Migration[8.0]
  def change
    create_table :google_sheets, id: :string do |t|
      t.references :course, null: false, foreign_key: true, index: true
      t.string :url, null: false
      t.string :name
      t.text :description
      t.jsonb :attrs, default: {}

      t.timestamps

      t.index :attrs, using: :gin
    end
  end
end
