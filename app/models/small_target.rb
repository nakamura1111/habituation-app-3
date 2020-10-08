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

  # アソシエーション
  belongs_to :target
end
