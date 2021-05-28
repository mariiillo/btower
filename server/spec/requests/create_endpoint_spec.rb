# frozen_string_literal: true

require 'rails_helper'

describe 'Create Endpoint' do
  context 'with valid params' do
    it 'creates a new endpoint and returns it serialized' do
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
              "body": '{ "message": "Hello, world" }'
            }
          }
        }
      }.to_json
      expected_response = {
        "type": 'endpoints',
        "attributes": {
          "verb": 'GET',
          "path": '/greeting',
          "response": {
            "code": 200,
            "headers": {},
            "body": '{ "message": "Hello, world" }'
          }
        }
      }.as_json

      action = -> { post '/endpoints', params: request, headers: headers }

      expect(action).to change(Endpoint, :count).by(1)
      expect(response).to have_http_status(201)
      expect(json['data']).to include expected_response
      expect(response.content_type).to eq 'application/vnd.api+json'
    end
  end

  context 'with invalid params' do
    it 'does not create an endpoint and returns errors' do
      create(:endpoint, verb: 'GET', path: '/greeting')
      headers = {
        'Content-Type': 'application/vnd.api+json',
        'Accept': 'application/vnd.api+json'
      }
      params = {
        "data": {
          "type": 'endpoints',
          "attributes": {
            "verb": 'GET',
            "path": '/greeting',
            "response": {
              "code": 200,
              "headers": "foo: 'bar'",
              "body": '{ "message": "Hello, world" }'
            }
          }
        }
      }.to_json
      expected_response = {
        "errors": [
          {
            'code': '100',
            'detail': 'path - has already been taken',
            'source': {
              'pointer': '/data/attributes/path'
            },
            'status': '422',
            'title': 'has already been taken'
          },
          {
            "code": '100',
            "detail": 'response - invalid format',
            "source": {
              "pointer": '/data/attributes/response'
            },
            "status": '422',
            "title": 'invalid format'
          }
        ],
      }.as_json

      action = -> { post '/endpoints', params: params, headers: headers }

      expect(action).not_to change(Endpoint, :count)
      expect(response).to have_http_status(422)
      expect(json).to eq expected_response
      expect(response.content_type).to eq 'application/vnd.api+json'
    end
  end
end
