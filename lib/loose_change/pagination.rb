module LooseChange

  module Pagination

    # Similar to <tt>#view_by</tt>, but adds a paginated view
    # compatible with <tt>will_paginate</tt>.
    def paginated_view_by(*keys)
      view_name = "paginated_by_#{ keys.join('_and_') }"
      map_code = "function(doc) {
                     if ((doc['model_name'] == '#{ model_name }') && #{ keys.map {|k| existence_check k}.join('&&') }) {
                       emit(#{ key_for(keys) }, 1)
                     }
                   }
                   "
      reduce_code = "function(keys, values) { return sum(values); }"
      add_view(view_name, map_code, reduce_code)
      view_by(*keys)
    end

    # Returns a <tt>will_paginate</tt>-compatible set of documents.
    # In +opts+, <tt>:per_page</tt> is required, and <tt>:page</tt>
    # will be set to 1 unless otherwise specified.  All other +opts+
    # will be passed to CouchDB as in <tt>:view_by</tt>.
    def paginated_by(view_name, opts = {})
      raise "You must include a per_page parameter" if opts[:per_page].nil?

      opts[:page] ||= 1

      WillPaginate::Collection.create( opts[:page], opts[:per_page] ) do |pager|
        total_result = view("paginated_by_#{ view_name }", :reduce => true)
        pager.total_entries = total_result ? total_result.first : 0

        results = if view_name == :all
                    view(view_name, :limit => opts[:per_page], :skip => ((opts[:page].to_i - 1) * opts[:per_page].to_i), :include_docs => true)
                  else
                    view("by_#{ view_name }", :key => opts[:key],  :limit => opts[:per_page], :skip => ((opts[:page].to_i - 1) * opts[:per_page].to_i), :include_docs => true)
                  end
        pager.replace( results )
      end
    end

    # Short for <tt>paginated_by(:all)</tt>; see
    # <tt>#paginated_by</tt> for +opts+.
    def paginate(opts = {})
      paginated_by(:all, opts)
    end
    
    private
    
    def paginated_view_by_all
      view_name = "paginated_by_all"
      map_code = "function(doc) {
                     if (doc['model_name'] == '#{ model_name }') {
                       emit(null, 1);
                     }
                   }
                   "
      reduce_code = "function(keys, values) { return sum(values); }"
      add_view(view_name, map_code, reduce_code)
    end
    
    def existence_check(key)
      "(#{ doc_key(key) } != null)"
    end
    
  end
  

end
