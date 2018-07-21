class Company < ApplicationRecord
  has_many :departments, primary_key: 'code', foreign_key: 'comid'
end
