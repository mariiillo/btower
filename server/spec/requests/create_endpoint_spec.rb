# frozen_string_literal: true

require 'rails_helper'

describe 'Create Endpoint' do
  context 'when condition' do
    it 'creates a new endpoint' do
      headers = {
        'Content-Type': 'application/vnd.api+json',
        'Accept': 'application/vnd.api+json'
      }
      request = {
        "data": {
          "type": 'endpoints',
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
      }.to_json
      expected_response = {
        "data": {
          "type": 'endpoints',
          "id": '12345',
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
      }
      expected_headers = {
        "Content-Type": 'application/vnd.api+json'
      }

      post '/endpoints', params: request, headers: headers

      # expect(response).to have_http_status(200)
      expect(json).to eq expected_response
      expect(response.headers).to eq expected_headers
    end
  end
end
