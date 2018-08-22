class News < ApplicationRecord
  validates :news_id, uniqueness: true

  DEFAULT_PER = 10
  paginates_per DEFAULT_PER

  enum category: { general: 0, support_notice: 1}
  default_scope { order(news_id: :desc) }
end
