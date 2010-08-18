require 'cgi'

module LooseChange
  module Persistence
        
    def find(id)
      result = JSON.parse(RestClient.get(self.database.uri + "/#{ id }"), default_headers)
      raise "Not Found" unless result['model_name'] == model_name
      model = new(result.reject {|k, _| 'model_name' == k})
      model.id = result['_id']
      model.new_record = false
      model
    end
        
    def default_headers
      {
        :content_type => :json,
        :accept       => :json
      }
    end
    
  end
  
  module PersistenceClassMethods

    attr_accessor :new_record, :destroyed, :database, :id, :_rev, :_id
    
    def new_record?()   @new_record end
    def destroyed?()    @destroyed  end
    
    def persisted?
      !(new_record? || destroyed?)
    end
    
    def save
      raise "Cannot save without database set." unless @database
      new_record? ? post_record : put_record
    end

    def destroy
      raise "Cannot destroy without database set." unless @database
      result = JSON.parse(RestClient.delete("#{ database.uri }/#{ CGI.escape(id) }?rev=#{ @_rev }", default_headers))['ok']
      @destroyed = result
    end
        
    private
    
    def post_record
      result = JSON.parse(RestClient.post(database.uri, self.to_json(:methods => [:model_name]), default_headers))
      @id = @_id = result['id']
      @_rev = result['rev']
      @new_record = false
      result
    end

    def put_record
      JSON.parse(RestClient.put(database.uri + "/#{ CGI.escape(id) }", self.to_json(:methods => [:model_name, :_rev, :_id], :except => [:id]), default_headers))['ok']
    end
    
    def default_headers
      {
        :content_type => :json,
        :accept       => :json
      }
    end
    
  end
end
