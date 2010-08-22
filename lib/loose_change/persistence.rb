require 'cgi'

module LooseChange
  module Persistence
    
    def use_database(db, server = "http://127.0.0.1:5984")
      self.database = Database.new(db, Server.new(server))
      Database.setup_design(self.database, self.model_name)
    end
    
    def find(id)
      begin
        result = JSON.parse(RestClient.get(self.database.uri + "/#{ id }"), default_headers)
      rescue RestClient::ResourceNotFound
        raise RecordNotFound
      end
      raise RecordNotFound unless result['model_name'] == model_name
      instantiate_from_hash(result)
    end
    
    def instantiate_from_hash(hash)
      model = new(hash.reject {|k, _| 'model_name' == k})
      model.id = hash['_id']
      model.new_record = false
      model
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
      raise DatabaseNotSet.new("Cannot save without database set.") unless @database
      return false unless valid?
      new_record? ? post_record : put_record
    end

    def destroy
      raise DatabaseNotSet.new("Cannot destroy without database set.") unless @database
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
    
  end

  class RecordNotFound < Exception
  end

  class DatabaseNotSet < Exception
  end
end
