module LooseChange
  module Helpers
    def design_document_uri(database, model_name)
      "#{ database.uri }/_design/#{ CGI.escape(model_name) }"
    end

    def default_headers
      {
        :content_type => :json,
        :accept       => :json
      }
    end
  end
end
