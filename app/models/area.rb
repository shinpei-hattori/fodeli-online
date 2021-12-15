class Area < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :prefecture
  validates :city, presence: true,uniqueness: true
end
