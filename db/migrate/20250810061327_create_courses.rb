class CreateCourses < ActiveRecord::Migration[8.0]
  def change
    create_table :courses do |t|
      t.string :name, null: false
      t.integer :year, null: false
      t.string :season, null: false
      t.text :description
      t.jsonb :attrs, default: {}

      t.timestamps

      t.index :attrs, using: :gin
    end
  end
end
