class Prefecture < ApplicationRecord
  has_many :areas
  validates :name, presence: true, uniqueness: true
end
