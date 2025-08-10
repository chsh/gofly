# frozen_string_literal: true

class GoogleService::ObjectSelector
  def self.from(meta)
    [ GoogleService::Sheet, GoogleService::Folder ].each do |klass|
      return klass.new(meta) if klass.me?(meta)
    end
    # other: default `File`
    GoogleService::File.new(meta)
  end
end
