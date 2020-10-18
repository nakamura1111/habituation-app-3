# 目標に関するデータを管理するためのモデル
class Target < ApplicationRecord
  # アソシエーション
  with_options presence: true do
    validates :name, length: { maximum: 20, allow_blank: true }
    validates :content, length: { maximum: 500, allow_blank: true }
    with_options numericality: { only_integer: true, allow_blank: true } do
      validates :point
      validates :level
      validates :exp
    end
  end

  # バリデーション
  belongs_to :user
  has_many :habits
  has_many :small_targets

  # attr_accessorでインスタンス変数作成すれば、levelとexp要らなかったね

  # レベルと経験値を算出するメソッド
  def self.level_and_exp_calc(point)
    level = point / 10 + 1
    exp = point % 10
    [level, exp]
  end

  # 習慣を達成することで得られるポイントを加算し、レベル・経験値を算出し直すメソッド
  def self.add_point_by_habit_achieve(habit, is_add)
    if is_add
      point = habit.target.point + habit.difficulty_grade + 1
      level, exp = Target.level_and_exp_calc(point)
      habit.target.update(point: point, level: level, exp: exp)
    end
    true
  end

  # 小目標を達成することで得られるポイントを加算し、レベル・経験値を算出し直すメソッド
  def self.add_point_by_small_target_achieve(small_target)
    if small_target.is_achieved
      point = small_target.target.point + small_target.happiness_grade + small_target.hardness_grade
      level, exp = Target.level_and_exp_calc(point)
      small_target.target.update(point: point, level: level, exp: exp)
    end
    true
  end
end
