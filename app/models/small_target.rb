class SmallTarget < ApplicationRecord
  # バリデーション
  validates :content, length: { maximum: 500 }
  with_options presence: true do
    validates :name, length: { maximum: 50, allow_blank: true }
    with_options numericality: { only_integer: true, allow_blank: true } do
      with_options if: :is_achieved do
        validates :happiness_grade, numericality: { other_than: 0 }
        validates :hardness_grade, numericality: { other_than: 0 }
      end
      with_options unless: :is_achieved do
        validates :happiness_grade, numericality: { equal_to: 0 }
        validates :hardness_grade, numericality: { equal_to: 0 }
      end
    end
  end
  validates :is_achieved, inclusion: { in: [true, false] }

  def recorded_happiness_and_hardness?
    return false if is_achieved == true && (happiness_grade.zero? || hardness_grade.zero?)

    true
  end

  # アソシエーション
  belongs_to :target

  # # happiness_gradeとhardness_gradeの加工
  # def mod_happiness_and_hardness
  #   return false if is_achieved
  #   happiness_grade = 0
  #   hardness_grade = 0
  #   true
  # end
end
