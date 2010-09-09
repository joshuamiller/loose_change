require 'cgi'

module LooseChange
  module Views
    
    def view(view_name, opts = {})
      include_docs = opts.include?(:include_docs) ? opts[:include_docs] : true
      JSON.parse(RestClient.get("#{ self.database.uri }/_design/#{ CGI.escape(self.model_name) }/_view/#{ view_name }?key=#{CGI.escape(opts[:key].to_json)}&include_docs=#{include_docs}", default_headers))['rows'].map do |row|
        include_docs ? instantiate_from_hash(row['doc']) : row['value']
      end
    end
    
    def view_by(*keys)
      view_name = "by_#{ keys.join('_and_') }"
      view_code = "function(doc) {
                     if ((doc['model_name'] == '#{ model_name }') && #{ keys.map {|k| existence_check k}.join('&&') }) {
                       emit(#{ key_for(keys) }, doc)
                     }
                   }
                   "
      add_view(view_name, view_code)
      self.class.send(:define_method, view_name.to_sym) do |*keys|
        keys = keys.first if keys.length == 1
        view(view_name, :key => keys, :include_docs => true)
      end
      
    end

    def create_view_method(name, &block)
      self.class.send(:define_method, name, &block)
    end
        
    def all
      JSON.parse(RestClient.get("#{ self.database.uri }/_design/#{ self.model_name }/_view/all", default_headers))['rows'].map { |row| instantiate_from_hash(row['value']) }
    end
    
    def add_view(name, code)
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
        "[#{keys.map {|k| doc_key(k) }.join(',')}]"
      end
    end

    def doc_key(key)
      "doc['#{ key }']"
    end
    
  end
end
