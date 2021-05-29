# frozen_string_literal: true

require 'rails_helper'

describe 'Call a defined endpoint' do
  it 'returns the configured response' do
    headers = {
      'Accept': 'application/json'
    }
    create(
      :endpoint,
      verb: 'GET',
      path: '/foo/bar/baz',
      response: {
        code: 200,
        headers: { 'Content-Type': 'application/json' },
        body: "{ 'hello': 'world' }"
      }
    )
    Server::Application.reload_routes!

    get '/foo/bar/baz', headers: headers

    expect(response).to have_http_status(200)
    expect(response.body).to eq "{ 'hello': 'world' }"
    expect(response.content_type).to eq 'application/json'
  end
end
