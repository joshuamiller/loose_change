require 'cgi'

module LooseChange
  module Views
    
    # Invoke a view identified by +view_name+ on this Loose Change
    # model's design document on CouchDB. Options specified in the
    # +opts+ hash will be passed along to CouchDB; for options see
    # http://wiki.apache.org/couchdb/Introduction_to_CouchDB_views
    def view(view_name, opts = {})
      opts[:key] = opts.has_key?(:key) ? CGI.escape(opts[:key].to_json) : nil
      param_string = opts.reject {|k,v| v.nil?}.map {|k,v| "#{k}=#{v}"}.join('&')
      JSON.parse(RestClient.get("#{ self.database.uri }/_design/#{ CGI.escape(self.model_name) }/_view/#{ view_name }?#{ param_string }", default_headers))['rows'].map do |row|
        opts[:include_docs] ? instantiate_from_hash(row['doc']) : row['value']
      end
    end

    # Set up a view that will allow you to query CouchDB by +keys+.  A
    # view will be added to the design document on CouchDB, and a
    # method to retrieve documents will be added to the Loose Change
    # model class.
    #
    #   class Recipe < LooseChange::Base
    #     property :name
    #     property :popularity
    #     view_by :name
    #     view_by :name, :popularity
    #   end
    #
    #   Recipe.by_name("lasagne")
    #   Recipe.by_name_and_popularity("lasagne", 4)
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
    
    # Retrieve all of this model's documents currently stored on CouchDB.
    def all(opts = {})
      view(:all, opts.merge!(:include_docs => true))
    end

    # Add a view to the this model's design document on CouchDB.  The
    # view is identified by +name+, defined by +map+ and optionally
    # +reduce+, which are composed of JavaScript functions.  For more
    # information on CouchDB views, see
    # http://wiki.apache.org/couchdb/Introduction_to_CouchDB_views 
    def add_view(name, map, reduce = nil)
      design_doc = JSON.parse(RestClient.get("#{ self.database.uri }/_design/#{ CGI.escape(self.model_name) }"))
      current_views = design_doc['views'] || {}
      JSON.parse(RestClient.put("#{ self.database.uri }/_design/#{ CGI.escape(self.model_name) }",
                                { '_id' => design_doc['_id'],
                                  '_rev' => design_doc['_rev'],
                                  'language' => 'javascript',
                                  'views' => current_views.merge({name => {'map' => map, 'reduce' => reduce}})}.to_json, default_headers))
    end
    
    #:nodoc:
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

    #:nodoc:
    def existence_check(key)
      "(#{ doc_key(key) } != null)"
    end
    
    #:nodoc:
    def key_for(keys)
      if keys.length == 1
        doc_key(keys.first)
      else
        "[#{keys.map {|k| doc_key(k) }.join(',')}]"
      end
    end
    
    #:nodoc:
    def doc_key(key)
      "doc['#{ key }']"
    end
    
  end
end
