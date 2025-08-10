# frozen_string_literal: true

class GoogleService::File < GoogleService::Base
  class_methods do
    def me?(meta)
      meta.kind == "drive#file"
    end
  end
end
