class Company < ApplicationRecord
  has_many :departments, foreign_key: 'comid'
end
