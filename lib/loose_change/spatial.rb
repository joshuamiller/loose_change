module LooseChange
  module Spatial

    def geo_point(name)
      design_doc = JSON.parse(RestClient.get("#{ database.uri }/_design/#{ CGI.escape(model_name) }"))
      RestClient.put("#{ database.uri }/_design/#{ CGI.escape(model_name) }",
                       design_doc.merge({"spatial" => {"points" => "function(doc) {\n    if (doc.#{name}) {\n        emit({\n            type: \"Point\",\n            coordinates: [doc.#{name}[0], doc.#{name}[1]]\n        }, [doc._id, doc.#{name}]);\n    }};"}}).to_json, default_headers)
      property(name)
    end
      
    def by_bounding_box(lat1, lng1, lat2, lng2)
      JSON.parse(RestClient.get("#{ database.uri }/_design/#{ CGI.escape(model_name) }/_spatial/points?bbox=#{ [lat1,lng1,lat2,lng2].join(',') }", default_headers))['rows'].map do |row|
        find(row['id'])
      end
    end
    
  end
end
