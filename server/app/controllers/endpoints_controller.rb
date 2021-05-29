# frozen_string_literal: true

class EndpointsController < ApplicationController
  include JSONAPI::ActsAsResourceController

  def serve
    endpoint = Endpoint.find_by(path: request.path)
    endpoint.response['headers'].each do |k, v|
      response.set_header(k, v)
    end
    render json: endpoint.response['body'], status: endpoint.response['code']
  end

  def invalid_route
    response.set_header('Content-Type', 'application/vnd.api+json')
    render json: {
      "errors": [{
        "code": 'not_found',
        "detail": I18n.t('errors.route_not_found', route: request.path)
      }]
    }, status: :not_found
  end
end
