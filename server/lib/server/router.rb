# frozen_string_literal: true

module Server
  class Router
    class << self
      def register_endpoint(endpoint)
        define_route endpoint
      end

      def load_endpoint_routes!
        return unless ActiveRecord::Base.connection.table_exists? 'endpoints'

        Endpoint.find_each do |endpoint|
          define_route endpoint
        end
      end

      private

      def define_route(endpoint)
        Server::Application.routes.instance_variable_set(:@disable_clear_and_finalize, true)
        Server::Application.routes.draw do
          send(
            endpoint.verb.downcase,
            endpoint.path,
            to: 'endpoints#serve',
          )
        end
      end
    end
  end
end
