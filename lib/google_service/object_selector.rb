# frozen_string_literal: true

class GoogleService::ObjectSelector
  def self.from(meta, service:)
    [ GoogleService::Sheet, GoogleService::Folder ].each do |klass|
      return klass.new(service, meta) if klass.me?(meta)
    end
    # other: default `File`
    GoogleService::File.new(service, meta)
  end
end
