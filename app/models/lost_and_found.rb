class LostAndFound < ApplicationRecord
  belongs_to :stu_user
  enum status: {created: 0, closed: 1}
  enum category: [:lost, :found]

  mount_uploader :images, LostAndFoundUploader

  DEFAULT_PER = 10
  paginates_per DEFAULT_PER

  validates :title, :describe, :category, :tel, presence: true
  validates :title, length: { maximum: 30 }
  validates :describe, length: { maximum: 200 }
  validates :tel, format: { with: /\d{11}|\d+-\d+-\d+/ }
end
