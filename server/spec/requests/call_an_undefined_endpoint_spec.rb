# frozen_string_literal: true

require 'rails_helper'

describe 'Call an undefined endpoint' do
  it 'returns an error response' do
    headers = {
      'Accept': 'application/json'
    }
    expected_response = {
      "errors": [
        {
          "code": 'not_found',
          "detail": "Requested page '/foo/bar/baz' does not exist"
        }
      ]
    }.as_json

    get '/foo/bar/baz', headers: headers

    expect(response).to have_http_status(404)
    expect(json).to eq expected_response
    expect(response.content_type).to eq 'application/vnd.api+json'
  end
end
