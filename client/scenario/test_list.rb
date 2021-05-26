# frozen_string_literal: true

require 'minitest/autorun'

require 'echo'

# TODOC: Add documentation
class TestList < Minitest::Test
  def test_server_to_implement_list_endpoint
    response = api.list_endpoints

    assert(response.success?)
  end

  def test_server_to_respond_with_http_ok
    response = api.list_endpoints

    exp = 200
    act = response.status_code

    assert_equal(exp, act)
  end

  def test_server_to_respond_with_json_body
    response = api.list_endpoints

    JSON.parse(response.body)
  end

  def test_server_to_respond_with_empty_list
    response = api.list_endpoints

    exp = { data: [] }
    act = JSON.parse(response.body, symbolize_names: true)

    assert_equal(exp, act)
  end

  private

  def api
    @api ||= Echo::API.new(server_url: ENV.fetch('SERVER_URL'))
  end
end
