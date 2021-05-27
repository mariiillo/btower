# frozen_string_literal: true

class EndpointResource < JSONAPI::Resource
  attributes :verb, :path, :response

  exclude_links :default
end
