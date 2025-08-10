# frozen_string_literal: true

class GoogleService::Base
  def initialize(service, meta)
    @service = service
    @meta = meta
  end
  attr_reader :service, :meta

  delegate :id, :kind, :mime_type, :name, to: :meta
end
