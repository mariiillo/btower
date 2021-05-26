class Response < ApplicationRecord
  belongs_to :endpoint

  validates :code, :endpoint, presence: true
end
