require 'cgi'

module LooseChange
  module Views
    
    def view(view_name, opts = {})
      opts[:key] = opts[:key] ? CGI.escape(opts[:key].to_json) : nil
      param_string = opts.reject {|k,v| v.nil?}.map {|k,v| "#{k}=#{v}"}.join('&')
      JSON.parse(RestClient.get("#{ self.database.uri }/_design/#{ CGI.escape(self.model_name) }/_view/#{ view_name }?#{ param_string }", default_headers))['rows'].map do |row|
        opts[:include_docs] ? instantiate_from_hash(row['doc']) : row['value']
      end
    end
    
    def view_by(*keys)
      view_name = "by_#{ keys.join('_and_') }"
      view_code = "function(doc) {
                     if ((doc['model_name'] == '#{ model_name }') && #{ keys.map {|k| existence_check k}.join('&&') }) {
                       emit(#{ key_for(keys) }, null)
                     }
                   }
                   "
      add_view(view_name, view_code)
      self.class.send(:define_method, view_name.to_sym) do |*keys|
        keys = keys.first if keys.length == 1
        view(view_name, :key => keys, :include_docs => true)
      end
    end

    def all(opts = {})
      view(:all, opts.merge!(:include_docs => true))
    end
    
    def add_view(name, map, reduce = nil)
      design_doc = JSON.parse(RestClient.get("#{ self.database.uri }/_design/#{ CGI.escape(self.model_name) }"))
      current_views = design_doc['views'] || {}
      JSON.parse(RestClient.put("#{ self.database.uri }/_design/#{ self.model_name }",
                                { '_id' => design_doc['_id'],
                                  '_rev' => design_doc['_rev'],
                                  'language' => 'javascript',
                                  'views' => current_views.merge({name => {'map' => map, 'reduce' => reduce}})}.to_json, default_headers))
    end

    def view_by_all
      view_name = "all"
      view_code = "function(doc) {
                     if (doc['model_name'] == '#{ model_name }') {
                       emit(null);
                     }
                   }
                   "
      add_view(view_name, view_code)
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
