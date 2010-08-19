require 'cgi'

module LooseChange
  module Views
    
    def view_by(*keys)
      view_name = "by_#{ keys.join('_and_') }"
      view_code = "function(doc) {
                     if ((doc['model_name'] == '#{ model_name }') && #{ keys.map {|k| existence_check k}.join('&&') }) {
                       emit(#{ key_for(keys) }, doc)
                     }
                   }
                   "
      add_to_views(view_name, view_code)
      self.class.send(:define_method, view_name.to_sym) do |key|
        JSON.parse(RestClient.get("#{ self.database.uri }/_design/#{ CGI.escape(self.model_name) }/_view/#{ view_name }?key=#{CGI.escape(key.to_json)}", default_headers))['rows'].map do |row|
          instantiate_from_hash(row['value'])
        end
      end
      
    end

    def create_view_method(name, &block)
      self.class.send(:define_method, name, &block)
    end
        
    def all
      JSON.parse(RestClient.get("#{ self.database.uri }/_design/#{ self.model_name }/_view/all", default_headers))['rows'].map { |row| instantiate_from_hash(row['value']) }
    end
    
    def add_to_views(name, code)
      design_doc = JSON.parse(RestClient.get("#{ self.database.uri }/_design/#{ CGI.escape(self.model_name) }"))
      current_views = design_doc['views']
      JSON.parse(RestClient.put("#{ self.database.uri }/_design/#{ self.model_name }",
                                { '_id' => design_doc['_id'],
                                  '_rev' => design_doc['_rev'],
                                  'language' => 'javascript',
                                  'views' => current_views.merge({name => {'map' => code}})}.to_json, default_headers))
    end

    def existence_check(key)
      "(#{ doc_key(key) } != null)"
    end

    def key_for(keys)
      if keys.length == 1
        doc_key(keys.first)
      else
        "[#{ keys.map {|k| doc_key(k) }}]"
      end
    end

    def doc_key(key)
      "doc['#{ key }']"
    end
    
  end
end
