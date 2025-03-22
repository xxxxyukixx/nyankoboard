class Profile < ApplicationRecord
  belongs_to :user
  has_one_attached :avatar

  validates :nickname, length: { maximum: 50 }
  validates :description, length: { maximum: 200 }
  validates :avatar,
    content_type: [ "image/png" ],
    size: { less_than: 1.megabytes }
end
