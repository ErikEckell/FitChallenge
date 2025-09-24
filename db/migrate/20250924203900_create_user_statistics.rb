class CreateUserStatistics < ActiveRecord::Migration[8.0]
  def change
    create_table :user_statistics do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :total_points
      t.float :total_distance
      t.integer :total_reps
      t.integer :total_minutes
      t.integer :completed_challenges
      t.datetime :last_update

      t.timestamps
    end
  end
end
