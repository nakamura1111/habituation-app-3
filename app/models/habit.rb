# 習慣に関するデータを管理するためのモデル
class Habit < ApplicationRecord
  # バリデーション
  validates :content, length: { maximum: 500 }
  with_options presence: true do
    validates :name, length: { maximum: 50, allow_blank: true }
    with_options numericality: { only_integer: true, allow_blank: true } do
      validates :difficulty_grade
      validates :achieved_or_not_binary
      validates :achieved_days, numericality: { less_than: 1_000_000_000, allow_blank: true }
      validates :active_days, numericality: { less_than: 1_000_000_000, allow_blank: true }
    end
  end
  validates :is_active, inclusion: { in: [true, false] }

  # アソシエーション
  belongs_to :target

  # ActiveHashによるアソシエーション
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :difficulty
  belongs_to_active_hash :achieved_status

  # 二進数データをview表示の形式に置き換える
  def self.translate_achieved_status(achieved_or_not_binary)
    display_days = 7
    statuses = []
    display_days.times do |i|
      # 新しい順に判定する
      if ((achieved_or_not_binary >> i) & 1) == 1
        statuses.push('〇') # 新しいデータが先頭になるように格納
      else
        statuses.push('×')
      end
    end
    statuses
  end

  # 日付を跨いだ際にDBの値を変更するメソッド
  def self.update_stat_by_day_progress
    puts " 'Habit.update_stat_by_day_progress' run at #{Time.now} "
    habits = Habit.all
    habits.each do |habit|
      active_days_tmp = if habit.is_active
                          habit.active_days + 1
                        else
                          habit.active_days
                        end
      habit.update(achieved_or_not_binary: habit.achieved_or_not_binary << 1, active_days: active_days_tmp)
    end
  end
end
