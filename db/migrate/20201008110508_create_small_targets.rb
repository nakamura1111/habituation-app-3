class CreateSmallTargets < ActiveRecord::Migration[6.0]
  def change
    create_table :small_targets do |t|
      t.string :name, null: false
      t.text :content
      t.integer :happiness_grade, null: false, default: 0
      t.integer :hardness_grade, null: false, default: 0
      t.boolean :is_ahieved, null: false, default: false
      t.references :target, null: false, foreign_key: true

      t.timestamps
    end
  end
end
