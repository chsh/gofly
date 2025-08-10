# frozen_string_literal: true

class GoogleService::Base
  def initialize(service, file_id)
    @service = service
    @file_id = file_id
  end
  attr_reader :service, :file_id
end
