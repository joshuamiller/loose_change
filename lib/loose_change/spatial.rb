module LooseChange
  module Spatial

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
    
    def by_bounding_box(name, lat1, lng1, lat2, lng2)
      JSON.parse(RestClient.get("#{ design_document_uri(database, model_name) }/_spatial/#{name}?bbox=#{ [lat1,lng1,lat2,lng2].join(',') }", default_headers))['rows'].map do |row|
        find(row['id'])
      end
    end
    
  end
end
