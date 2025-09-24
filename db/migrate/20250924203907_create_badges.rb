class CreateBadges < ActiveRecord::Migration[8.0]
  def change
    create_table :badges do |t|
      t.string :name
      t.text :description
      t.text :condition

      t.timestamps
    end
  end
end
