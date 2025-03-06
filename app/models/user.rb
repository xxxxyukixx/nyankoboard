class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true,               # null: false に対応
                  uniqueness: { case_sensitive: false }, # unique: true に対応
                  length: { minimum: 3, maximum: 30 }    # 任意の長さ制限

	has_many :posts
	has_one :profile, dependent: :destroy

	after_create :create_default_profile  # ユーザー作成後に実行

	private

  def create_default_profile
    create_profile(
      nickname: name,
      description: "よろしくお願いします！"
    )
  end
end
