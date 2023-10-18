# frozen_string_literal: true

if error_object.errors.size.eql?(1)
  error = error_object.errors.first
  json.error error.full_message
else
  json.errors error_object.errors.full_messages
end
