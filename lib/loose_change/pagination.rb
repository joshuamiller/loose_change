require 'will_paginate/collection'

module LooseChange

  module Pagination
    
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
    
    def paginated_view(view_name, opts = {})
      raise "You must include a per_page parameter" if opts[:per_page].nil?

      opts[:page] ||= 1

      WillPaginate::Collection.create( opts[:page], opts[:per_page] ) do |pager|
        total_result = view("paginated_#{ view_name }", :reduce => true)
        pager.total_entries = total_result ? total_result.first : 0

        results = view(view_name, :limit => opts[:per_page], :skip => ((opts[:page].to_i - 1) * opts[:per_page].to_i))
        pager.replace( results )
      end
    end
    
    def paginate(opts = {})
      paginated_view(:all, opts)
    end
    
    private
    
    def paginated_view_by_all
      view_name = "paginated_all"
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
