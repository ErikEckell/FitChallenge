class CreateParticipations < ActiveRecord::Migration[8.0]
  def change
    create_table :participations do |t|
      t.references :user, null: false, foreign_key: true
      t.references :challenge, null: false, foreign_key: true
      t.datetime :joined_at
      t.integer :total_points
      t.string :status

      t.timestamps
    end
    add_index :participations, [:user_id, :challenge_id], unique: true
  end
end
