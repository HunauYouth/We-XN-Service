class LostAndFound < ApplicationRecord
  belongs_to :stu_user
  enum status: {created: 0, closed: 1}
  enum category: [:lost, :found]

  mount_uploader :images, LostAndFoundUploader
end
