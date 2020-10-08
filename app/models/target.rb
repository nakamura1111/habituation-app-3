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

  # attr_accessorでインスタンス変数作成すれば、levelとexp要らなかったね

  # レベルと経験値を算出するメソッド
  def self.level_and_exp_calc(point)
    level = point / 10 + 1
    exp = point % 10
    [level, exp]
  end

  # 習慣を達成することで得られるポイントを加算し、レベル・経験値を算出し直すメソッド
  def self.add_target_point(habit, is_add)
    if is_add
      point = habit.target.point + habit.difficulty_grade + 1
      level, exp = Target.level_and_exp_calc(point)
      habit.target.update(point: point, level: level, exp: exp)
    end
    true
  end
end
