class AddActiveDaysToHabits < ActiveRecord::Migration[6.0]
  def change
    add_column :habits, :active_days, :integer, null: false, default: 1
  end
end
