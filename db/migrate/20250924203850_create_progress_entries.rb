class CreateProgressEntries < ActiveRecord::Migration[8.0]
  def change
    create_table :progress_entries do |t|
      t.references :participation, null: false, foreign_key: true
      t.references :exercise, null: false, foreign_key: true
      t.date :entry_date
      t.float :metric_value
      t.integer :points
      t.text :notes

      t.timestamps
    end
  end
end
