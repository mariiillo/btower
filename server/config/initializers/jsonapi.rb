module JSONAPI
  module Exceptions
    class RecordNotFound < Error
      def errors
        [create_error_object(
          code: :not_found,
          status: :not_found,
          detail: I18n.t('jsonapi-resources.exceptions.record_not_found.detail', id: id)
          )
        ]
      end
    end

    class ValidationErrors < Error
      def json_api_error(attr_key, message)
        create_error_object(
          code: :unprocessable_entity,
          status: :unprocessable_entity,
          detail: detail(attr_key, message)
        )
      end
    end
  end
end
