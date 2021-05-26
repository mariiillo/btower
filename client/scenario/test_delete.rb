# frozen_string_literal: true

require 'json'
require 'minitest/autorun'
require 'securerandom'

require 'echo'

# TODOC: Add documentation
class TestDelete < Minitest::Test
  def setup
    # Create an endpoints that will be used as a test subject
    response = api.create_endpoint(verb: 'GET',
                                   path: '/foo',
                                   response: {
                                     code: 200,
                                     headers: {},
                                     body: JSON.generate({ message: 'Hello world' })
                                   })
    @endpoint = Echo::Endpoint.make_from_response(response)
  end

  def test_server_to_implement_delete_endpoint
    response = api.delete_endpoint(@endpoint.id)

    assert(response.success?)
  end

  def test_server_to_respond_with_http_no_content
    response = api.delete_endpoint(@endpoint.id)

    exp = 204
    act = response.status_code

    assert_equal(exp, act)
  end

  def test_server_to_delete_requested_endpoint
    skip
  end

  def test_server_to_refuse_to_delete_non_existing_endpoint
    response = api.delete_endpoint(@endpoint.id)

    exp = 404
    act = response.status_code

    assert_equal(exp, act)
  end

  private

  def api
    @api ||= Echo::API.new(server_url: ENV.fetch('SERVER_URL'))
  end
end
