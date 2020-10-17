class SmallTarget < ApplicationRecord
  # バリデーション
  validates :content, length: { maximum: 500 }
  with_options presence: true do
    validates :name, length: { maximum: 50, allow_blank: true }
    with_options numericality: { only_integer: true, allow_blank: true } do
      validates :happiness_grade
      validates :hardness_grade
    end
  end
  validates :is_achieved, inclusion: { in: [true, false] }

  def is_recorded_happiness_and_hardness
    return false if is_achieved == true && ( happiness_grade == 0 || hardness_grade == 0 )
    return true
  end

  # アソシエーション
  belongs_to :target

  # happiness_gradeとhardness_gradeの加工
  def regist_happiness_and_hardness
    if is_achieved == false
      happiness_grade = 0
      hardness_grade = 0
    end
  end
end
