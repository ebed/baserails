# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit
  def append_info_to_payload(payload)
    super
    # adding remote ip address
    payload[:remote_ip] = request.remote_ip
    # conditionally add something
    # payload[:some_field] = some_value if some_condition
  end
end
