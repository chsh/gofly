class CreateStudents < ActiveRecord::Migration[8.0]
  def change
    create_table :students do |t|
      t.string :email, null: false, index: { unique: true }
      t.string :name
      t.string :name_reading
      t.text :description
      t.jsonb :attrs, default: {}

      t.timestamps

      t.index :attrs, using: :gin
    end
  end
end
