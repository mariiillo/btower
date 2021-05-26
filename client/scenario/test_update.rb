# frozen_string_literal: true

require 'json'
require 'minitest/autorun'
require 'securerandom'

require 'echo'

# TODOC: Add documentation
class TestUpdate < Minitest::Test
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

    # Create an endpoints that will be used as a test subject
    response = api.create_endpoint(**@payload)
    @endpoint = Echo::Endpoint.make_from_response(response)
  end

  def test_server_to_implement_update_endpoint
    response = api.update_endpoint(@endpoint.id, **@payload)

    assert(response.success?)
  end

  def test_server_to_respond_with_http_ok
    response = api.update_endpoint(@endpoint.id, **@payload)

    exp = 200
    act = response.status_code

    assert_equal(exp, act)
  end

  def test_server_to_apply_requested_changes
    skip
  end

  def test_server_to_refuse_invalid_http_verbs
    @payload[:verb] = 'FOO'
    response = api.update_endpoint(@endpoint.id, **@payload)

    exp = 422
    act = response.status_code

    assert_equal(exp, act)
  end

  def test_server_to_response_with_error_message
    skip
  end

  # The list of unexpected characters is based on RFC 3986.
  # See https://tools.ietf.org/html/rfc3986
  def test_server_to_refuse_invalid_path
    %w[` > < |].each do |char|
      @payload[:path] = char
      response = api.update_endpoint(SecureRandom.hex, **@payload)

      exp = 422
      act = response.status_code

      assert_equal(exp, act)
    end
  end

  def test_server_to_refuse_to_update_non_existing_endpoint
    response = api.update_endpoint(@endpoint.id, **@payload)

    exp = 404
    act = response.status_code

    assert_equal(exp, act)
  end

  private

  def api
    @api ||= Echo::API.new(server_url: ENV.fetch('SERVER_URL'))
  end
end
