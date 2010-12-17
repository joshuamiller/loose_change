module LooseChange
  module Spatial

    def geo_point(name)
      design_doc = JSON.parse(RestClient.get(design_document_uri(database, model_name)))
      function =<<JS
        function(doc) {
          if (doc.#{name} && doc.model_name == "#{ model_name }") {
            emit({ type: "Point",
                   coordinates: doc.#{name} },
                 [doc._id, doc.#{name}]); }
        }
JS
      RestClient.put(design_document_uri(database, model_name),
                     design_doc.merge({"spatial" => {name => function}}).to_json, default_headers)
      property(name)
    end
    
    def geo_multipoint(name)
      design_doc = JSON.parse(RestClient.get(design_document_uri(database, model_name)))
      function =<<JS
        function(doc) {
          if (doc.#{name} && doc.model_name == "#{ model_name }") {
            emit({ type: "MultiPoint",
                   coordinates: doc.#{name} },
                 [doc._id, doc.#{name}]); }};
JS
      RestClient.put(design_document_uri(database, model_name),
                     design_doc.merge({"spatial" => {name => function}}).to_json, default_headers)
      property(name)
    end
    
    def by_bounding_box(name, lat1, lng1, lat2, lng2)
      JSON.parse(RestClient.get("#{ design_document_uri(database, model_name) }/_spatial/#{name}?bbox=#{ [lat1,lng1,lat2,lng2].join(',') }", default_headers))['rows'].map do |row|
        find(row['id'])
      end
    end
    
  end
end
