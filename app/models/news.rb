class News < ApplicationRecord
  DEFAULT_PER = 10
  paginates_per DEFAULT_PER

  enum category: { general: 0, support_notice: 1, xshd: 2}
  default_scope { order(addtime: :desc) }
  validates :title, uniqueness: true
end
