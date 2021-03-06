# frozen_string_literal: true

require 'server/router'

Rails.application.routes.draw do
  jsonapi_resources :endpoints

  Server::Router.load_endpoint_routes!

  match '*path', to: 'endpoints#invalid_route', via: :all
end
