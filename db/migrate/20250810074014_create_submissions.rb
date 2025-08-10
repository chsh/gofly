class CreateSubmissions < ActiveRecord::Migration[8.0]
  def change
    create_table :submissions do |t|
      t.references :student, null: false, foreign_key: true, index: true
      t.string :type
      t.jsonb :attrs, default: {}

      t.timestamps

      t.index :type
    end
  end
end
