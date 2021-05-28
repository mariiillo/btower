# frozen_string_literal: true

class Endpoint < ApplicationRecord
  JSON_SCHEMA = "#{Rails.root}/app/models/schemas/endpoint/response.json"

  validates :verb, :path, presence: true
  validates :path, uniqueness: true
  validates :response, presence: true, json: { schema: JSON_SCHEMA }

  after_create :register_route

  private

  def register_route
    Server::Router.register_endpoint(self)
  end
end
