# frozen_string_literal: true

require 'json'
require 'minitest/autorun'

require 'echo'

# TODOC: Add documentation
class TestCreate < Minitest::Test
  def setup
    @payload = {
      verb: 'GET',
      path: '/foo',
      response: {
        code: 200,
        headers: {},
        body: JSON.generate({ message: 'Hello world' })
      }
    }
  end

  def test_server_to_implement_create_endpoint
    response = api.create_endpoint(**@payload)

    assert(response.success?)
  end

  def test_server_to_respond_with_http_created
    response = api.create_endpoint(**@payload)

    exp = 201
    act = response.status_code

    assert_equal(exp, act)
  end

  def test_server_to_implement_requested_endpoint
    skip
  end

  def test_server_to_refuse_to_create_duplicate_endpoint
    skip
  end

  def test_server_to_refuse_invalid_http_verbs
    @payload[:verb] = 'FOO'
    response = api.create_endpoint(**@payload)

    assert(response.success?)
    assert_equal(422, response.status_code)
  end

  # The list of unexpected characters is based on RFC 3986.
  # See https://tools.ietf.org/html/rfc3986
  def test_server_to_refuse_invalid_path
    %w[` > < |].each do |char|
      @payload[:path] = char
      response = api.create_endpoint(**@payload)

      assert(response.success?)
      assert_equal(422, response.status_code)
    end
  end

  private

  def api
    @api ||= Echo::API.new(server_url: ENV.fetch('SERVER_URL'))
  end
end
