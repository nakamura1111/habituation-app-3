class CreateHabits < ActiveRecord::Migration[6.0]
  def change
    create_table :habits do |t|
      t.string :name, null: false
      t.text :content
      t.integer :difficulty_grade, null: false
      t.integer :achieved_or_not_binary, null: false
      t.integer :achieved_days, null: false
      t.boolean :is_active, null: false
      t.references :target, null: false, foreign_key: true

      t.timestamps
    end
  end
end
