class Post < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  validates :content, presence: true, length: { maximum: 100 }
  validates :image,
    content_type: [ "image/png" ],
    size: { less_than: 1.megabytes },
    limit: { max: 3 }

    def self.ransackable_attributes(auth_object = nil)
      [ "content" ]
    end
end
