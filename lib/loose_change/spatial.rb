module LooseChange
  module Spatial
    # To define a spatial geometry property on a CouchDB document, use
    # the geo_* methods as following:
    #
    #   class Bar < LooseChange::Base
    #     geo_point :location
    #     geo_multipoint :catchment_area
    #   end
    #
    #   bar = Bar.new(:location => [41.3913, 73.9813])
    #
    # For information on geometries see the GeoJSON documentation at
    # http://geojson.org/geojson-spec.html
    
    GEOMETRIES = %w(Point MultiPoint)

    GEOMETRIES.each do |type|
      define_method("geo_#{type}".downcase.to_sym) do |name|
        design_doc = JSON.parse(RestClient.get(design_document_uri(database, model_name)))
        function =<<JS
        function(doc) {
          if (doc.#{name} && doc.model_name == "#{ model_name }") {
            emit({ type: "#{type}",
                   coordinates: doc.#{name} },
                 [doc._id, doc.#{name}]); }
        }
JS
        RestClient.put(design_document_uri(database, model_name),
                       design_doc.merge({"spatial" => (design_doc["spatial"] || {}).merge({ name => function })}).to_json, default_headers)
        property(name)
      end
    end
    
    # Locate documents with a bounding box (defined as two coordinate
    # pairs, from lower-left to upper-right).  The <tt>:name</tt>
    # parameter identifies which location property to search.
    #
    #   Bar.by_bounding_box(:location, 40, 72, 43, 74)
    def by_bounding_box(name, lat1, lng1, lat2, lng2)
      JSON.parse(RestClient.get("#{ design_document_uri(database, model_name) }/_spatial/#{name}?bbox=#{ [lat1,lng1,lat2,lng2].join(',') }", default_headers))['rows'].map do |row|
        find(row['id'])
      end
    end
    
  end
end
