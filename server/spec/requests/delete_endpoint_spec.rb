# frozen_string_literal: true

require 'rails_helper'

describe 'Delete Endpoint' do
  context 'with valid params' do
    it 'deletes an endpoint and returns it serialized' do
      endpoint = create(:endpoint)
      headers = { 'Accept': 'application/vnd.api+json' }

      action = -> { delete "/endpoints/#{endpoint.id}", headers: headers }

      expect(action).to change(Endpoint, :count).from(1).to(0)
      expect(response).to have_http_status(204)
    end
  end

  context 'with invalid params' do
    it 'returns error if the endpoint was not defined' do
      headers = { 'Accept': 'application/vnd.api+json' }
      expected_response = {
        "errors": [
          {
            "title": 'Record not found',
            "detail": 'The record identified by 12 could not be found.',
            "code": '404',
            "status": '404'
          }
        ]
      }.as_json

      action = -> { delete '/endpoints/12', headers: headers }

      expect(action).not_to change(Endpoint, :count)
      expect(response).to have_http_status(404)
      expect(json).to eq expected_response
      expect(response.content_type).to eq 'application/vnd.api+json'
    end
  end
end
