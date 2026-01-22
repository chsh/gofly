class AddKeyToGoogleModels < ActiveRecord::Migration[8.0]
  def change
    tables = %i(google_forms google_files google_sheets)
    tables.each do |table|
      add_column table, :key, :string
      add_index table, :key
    end
  end
end
