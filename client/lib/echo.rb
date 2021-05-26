# frozen_string_literal: true

require 'faraday'
require 'json'

# TODOC: Add documentation
module Echo
  # TODOC: Add documentation
  class API
    # TODOC: Add documentation
    # TODO: Add Accept header
    def initialize(server_url:)
      @connection = Faraday.new(url: server_url,
                                headers: { 'Content-Type' => 'application/json' })
    end

    def endpoints_api_url
      @server_url ||= @connection.build_url(endpoints)
    end

    def create_endpoint(verb:, path:, response:)
      response = @connection.post('endpoints', JSON.generate({
                                                               data: {
                                                                 type: 'endpoints',
                                                                 attributes: {
                                                                   verb: verb,
                                                                   path: path,
                                                                   response: {
                                                                     code: response.fetch(:code),
                                                                     headers: response.fetch(:headers, {}),
                                                                     body: response.fetch(:body, nil)
                                                                   }
                                                                 }
                                                               }
                                                             }))

      Response.success(response)
    rescue Faraday::Error => e
      Response.failure(error: e)
    end

    def list_endpoints
      response = @connection.get('endpoints')

      Response.success(response)
    rescue Faraday::Error => e
      Response.failure(error: e)
    end

    def update_endpoint(id, verb:, path:, response:)
      response = @connection.patch("endpoints/#{id}", JSON.generate({
                                                               data: {
                                                                 type: 'endpoints',
                                                                 id: id,
                                                                 attributes: {
                                                                   verb: verb,
                                                                   path: path,
                                                                   response: {
                                                                     code: response.fetch(:code),
                                                                     headers: response.fetch(:headers, {}),
                                                                     body: response.fetch(:body, nil)
                                                                   }
                                                                 }
                                                               }
                                                             }))

      Response.success(response)
    rescue Faraday::Error => e
      Response.failure(error: e)
    end

    def delete_endpoint(id)
      response = @connection.delete("endpoints/#{id}")

      Response.success(response)
    rescue Faraday::Error => e
      Response.failure(error: e)
    end
  end

  # TODOC: Add documentation
  class Response
    def self.success(response)
      new(response: response,
          error: nil)
    end

    def self.failure(error)
      new(response: nil,
          error: error)
    end

    def initialize(response:, error: nil)
      @response = response
      @error = error
    end

    def success?
      @error.nil?
    end

    def failure?
      @response.nil?
    end

    def status_code
      return if failure?

      @response.status
    end

    def body
      return if failure?

      @response.body
    end
  end

  # TODOC: Add documentation
  class Endpoint
    Error = Class.new(StandardError)

    class Response
      attr_reader :code,
                  :headers,
                  :body

      def initialize(code:, headers: {}, body: nil)
        @code = code
        @headers = headers
        @body = body
      end
    end

    attr_reader :id,
                :verb,
                :path,
                :response

    def self.make_from_response(response)
      raise(Error, 'cannot make an Endpoint from failed response') if response.failure?

      data = JSON.parse(response.body, symbolize_names: true)
      new(id: data.dig(:id),
          verb: data.dig(:data, :attributes, :verb),
          path: data.dig(:data, :attributes, :path),
          response: data.dig(:data, :attributes, :response))
    end

    def initialize(id:, verb:, path:, response:)
      @id = id
      @verb = verb
      @path = path
      @response = Response.new(**response)
    end
  end
end
