class CreateChallenges < ActiveRecord::Migration[8.0]
  def change
    create_table :challenges do |t|
      t.string :title
      t.text :description
      t.date :start_date
      t.date :end_date
      t.references :creator, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
