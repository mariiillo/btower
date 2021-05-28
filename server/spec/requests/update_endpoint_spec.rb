# frozen_string_literal: true

require 'rails_helper'

describe 'Update Endpoint' do
  context 'with valid params' do
    it 'updates an endpoint and returns it serialized' do
      endpoint = create(:endpoint, verb: 'GET', path: '/greetings', response: { code: 200 })
      headers = {
        'Content-Type': 'application/vnd.api+json',
        'Accept': 'application/vnd.api+json'
      }
      request = {
        "data": {
          "type": 'endpoints',
          "id": endpoint.id.to_s,
          "attributes": {
            "verb": 'POST',
            "path": '/updated_path',
            "response": {
              "code": 404,
              "headers": { "foo": 'bar' },
              "body": '{ "message": "Bye, everyone" }'
            }
          }
        }
      }.to_json
      expected_response = {
        "data": {
          "type": 'endpoints',
          "id": endpoint.id.to_s,
          "attributes": {
            "verb": 'POST',
            "path": '/updated_path',
            "response": {
              "code": 404,
              "headers": { "foo": 'bar' },
              "body": '{ "message": "Bye, everyone" }'
            }
          }
        }
      }.as_json

      action = -> { patch "/endpoints/#{endpoint.id}", params: request, headers: headers }

      expect(action).not_to change(Endpoint, :count)
      expect(response).to have_http_status(200)
      expect(json).to eq expected_response
      expect(response.content_type).to eq 'application/vnd.api+json'
    end
  end

  context 'with invalid params' do
    it 'returns errors' do
      endpoint = create(:endpoint, verb: 'GET', path: '/greetings', response: { code: 200 })
      headers = {
        'Content-Type': 'application/vnd.api+json',
        'Accept': 'application/vnd.api+json'
      }
      request = {
        "data": {
          "type": 'endpoints',
          "id": endpoint.id.to_s,
          "attributes": {
            "verb": 'POST',
            "path": '/updated_path',
            "response": {
              "code": 404,
              "headers": '{ "foo": "bar" }',
              "body": { "message": 'Bye, everyone' }
            }
          }
        }
      }.to_json
      expected_response = {
        "errors": [
          {
            "code": '100',
            "detail": 'response - invalid format',
            "source": { 'pointer': '/data/attributes/response' },
            "status": '422',
            "title": 'invalid format'
          }
        ]
      }.as_json

      action = -> { patch "/endpoints/#{endpoint.id}", params: request, headers: headers }

      expect(action).not_to change(Endpoint, :count)
      expect(response).to have_http_status(422)
      expect(json).to eq expected_response
      expect(response.content_type).to eq 'application/vnd.api+json'
    end

    it 'returns error if the endpoint was not defined' do
      headers = {
        'Content-Type': 'application/vnd.api+json',
        'Accept': 'application/vnd.api+json'
      }
      request = {
        "data": {
          "type": 'endpoints',
          "id": '12',
          "attributes": {
            "verb": 'POST',
            "path": '/updated_path',
            "response": {
              "code": 404,
              "headers": { "foo": 'bar' },
              "body": '{ "message": "Bye, everyone" }'
            }
          }
        }
      }.to_json
      expected_response = {
        "errors": [
          {
            "code": '404',
            "detail": 'The record identified by 12 could not be found.',
            "status": '404',
            "title": 'Record not found'
          }
        ]
      }.as_json

      action = -> { patch '/endpoints/12', params: request, headers: headers }

      expect(action).not_to change(Endpoint, :count)
      expect(response).to have_http_status(404)
      expect(json).to eq expected_response
      expect(response.content_type).to eq 'application/vnd.api+json'
    end
  end
end
