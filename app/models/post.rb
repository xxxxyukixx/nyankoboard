class Post < ApplicationRecord
  belongs_to :user
  has_many_attached :images

  validates :content, presence: true, length: { maximum: 100 }
  validates :images,
    content_type: ['image/png'],
    size: { less_than: 1.megabytes },
    limit: { max: 3 }
end
