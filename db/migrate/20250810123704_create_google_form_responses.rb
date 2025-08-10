class CreateGoogleFormResponses < ActiveRecord::Migration[8.0]
  def change
    create_table :google_form_responses do |t|
      t.references :google_form, type: :string, null: false, foreign_key: true, index: false
      t.integer :index, null: false
      t.jsonb :response, null: false
      t.string :digest, null: false
      t.datetime :submitted_at, null: false

      t.timestamps

      t.index [ :google_form_id, :index ], unique: true
      t.index :response, using: :gin
      t.index :digest
      t.index :submitted_at
    end
  end
end
