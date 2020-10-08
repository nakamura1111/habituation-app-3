class CreateTargets < ActiveRecord::Migration[6.0]
  def change
    create_table :targets do |t|
      t.string :name, null: false
      t.text :content, null: false
      t.integer :point, null: false
      t.integer :level, null: false
      t.integer :exp, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
