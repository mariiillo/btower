class Endpoint < ApplicationRecord
  validates :verb, :path, presence: true
  validates :path, uniqueness: true

  has_one :response
end
