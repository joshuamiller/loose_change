module LooseChange
  module Helpers
    def default_headers
      {
        :content_type => :json,
        :accept       => :json
      }
    end
  end
end
