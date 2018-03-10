class News < ApplicationRecord
  validates :news_id, uniqueness: true

  DEFAULT_PER = 10
  paginates_per DEFAULT_PER
end
