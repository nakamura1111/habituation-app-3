# ユーザに関するデータを管理するためのモデル
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  with_options presence: true do
    validates :nickname
    # uniquenessについて、Rails6.1にする場合、読んで欲しい、https://qiita.com/jnchito/items/e23b1facc72bd86234b6
    validates :email,    uniqueness: { case_sensitive: true, allow_blank: true }
    validates :password, format: { with: /\A(?=.*?[a-zA-Z])(?=.*?\d)[a-zA-Z\d]{7,}\z/, allow_blank: true }
  end

  has_many :targets
end
