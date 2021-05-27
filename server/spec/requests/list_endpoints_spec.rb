# frozen_string_literal: true

require 'rails_helper'

describe 'List Endpoints' do
  context 'when there are configured endpoints' do
    it 'lists the endpoints' do
      headers = {
        'Content-Type': 'application/vnd.api+json',
        'Accept': 'application/vnd.api+json'
      }
      endpoint = create(:endpoint, verb: 'GET', path: '/greeting')
      expected_response = {
        "data": [
          {
            "type": 'endpoints',
            "id": endpoint.id.to_s,
            "attributes": {
              "verb": 'GET',
              "path": '/greeting',
              "response": {
                "code": 200,
                "headers": {},
                "body": '"{ "message": "Hello, world" }"'
              }
            }
          }
        ]
       }.as_json

      get '/endpoints', headers: headers

      expect(response).to have_http_status(200)
      expect(json).to eq expected_response
      expect(response.content_type).to eq 'application/vnd.api+json'
    end
  end

  context 'when there are not configured endpoints' do
    it 'returns an empty array' do
      headers = {
        'Content-Type': 'application/vnd.api+json',
        'Accept': 'application/vnd.api+json'
      }
      expected_response = {
        "data": []
      }.as_json

      get '/endpoints', headers: headers

      expect(response).to have_http_status(200)
      expect(json).to eq expected_response
      expect(response.content_type).to eq 'application/vnd.api+json'
    end
  end
end
