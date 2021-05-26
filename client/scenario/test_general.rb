# frozen_string_literal: true

require 'json'
require 'minitest/autorun'

require 'echo'

# TODOC: Add documentation
class TestGeneral < Minitest::Test
  def test_server_to_refuse_bad_requests_to_endpoints_api
    skip
  end

  private

  def api
    @api ||= Echo::API.new(server_url: ENV.fetch('SERVER_URL'))
  end
end
