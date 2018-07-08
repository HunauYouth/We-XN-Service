class Notice < ApplicationRecord
  validates :notice, presence: true,
                     uniqueness: true
  enum status: [ :archived, :active ]
end
