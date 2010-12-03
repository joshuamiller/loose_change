require 'cgi'

module LooseChange
  module Persistence
    
    # Set the database source for this model, named +db+ on +server+
    # (http://localhost:5984 by default).  If the database does not
    # exist, it will be added.
    def use_database(db, server = "http://127.0.0.1:5984")
      self.database = Database.new(db, Server.new(server))
      Database.setup_design(self.database, self.model_name)
      view_by_all
      paginated_view_by_all
    end

    # Retrieve a document from CouchDB with id +id+ as a Loose Change instance.
    def find(id)
      begin
        result = JSON.parse(RestClient.get(self.database.uri + "/#{ id }"), default_headers)
      rescue RestClient::ResourceNotFound
        raise RecordNotFound
      end
      raise RecordNotFound unless result['model_name'] == model_name
      instantiate_from_hash(result)
    end

    # Instantiate a new Loose Change record with attributes +args+ and
    # immediately save to the database.
    def create(args = {})
      model = new(args)
      model.save
      model
    end
    
    # Instantiate a new Loose Change record with attributes +args+ and
    # immediately save to the database.  If the record is invalid, a
    # <tt>RecordInvalid</tt> error will be thrown.
    def create!(args = {})
      new(args).save!
    end

    # Build a Loose Change record from a hash of attributes +hash+ as
    # returned by CouchDB.
    def instantiate_from_hash(hash)
      model = new(hash.reject {|k, _| 'model_name' == k})
      model.id = hash['_id']
      model.new_record = false
      if hash['_attachments']
        attachment_names = hash['_attachments'].map {|name, _| name}
        model.attachments = attachment_names.inject({}) {|acc, name| acc[name] = {:content_type => hash['_attachments'][name]['content_type']}; acc}
      end
      model
    end
    
  end
  
  module PersistenceClassMethods

    attr_accessor :new_record, :destroyed, :database, :id, :_rev, :_id, :_attachments
    
    def new_record?()   @new_record end
    def destroyed?()    @destroyed  end
    
    def persisted?
      !(new_record? || destroyed?)
    end

    # Persist the record to CouchDB, including saving of any attachments.
    def save
      if new_record?
        _run_create_callbacks { _run_save_callbacks { _save } }
      else
        _run_save_callbacks { _save }
      end
    end
    
    # Persist the record to CouchDB, including saving of any
    # attachments. If the record is not valid, a
    # <tt>RecordInvalid</tt> error will be thrown.
    def save!
      if new_record?
        _run_create_callbacks { _run_save_callbacks { _save! } }
      else
        _run_save_callbacks { _save! }
      end
    end
    
    # Destroy the record on CouchDB by sending an HTTP DELETE request.
    def destroy
      _run_destroy_callbacks do
        raise DatabaseNotSet.new("Cannot destroy without database set.") unless @database
        result = JSON.parse(RestClient.delete("#{ database.uri }/#{ CGI.escape(id) }?rev=#{ @_rev }", default_headers))['ok']
        @destroyed = result
      end
    end
    
    private

    def _save
      raise DatabaseNotSet.new("Cannot save without database set.") unless @database
      apply_defaults
      return false unless valid?
      new_record? ? post_record : put_record
      put_attachments
      self
    end
    
    def _save!
      raise RecordInvalid, self.errors.map {|k, v| "#{k.capitalize} #{v}"}.join(', ') unless _save
      self
    end
    
    def uri
      "#{database.uri}/#{ CGI.escape(id) }"
    end
    
    def post_record
      result = JSON.parse(RestClient.post(database.uri, self.to_json(:methods => [:model_name]), default_headers))
      @id = @_id = result['id']
      @_rev = result['rev']
      @new_record = false
      result
    end

    def put_record
      if self._attachments
        result = JSON.parse(RestClient.put(uri, self.to_json(:methods => [:model_name, :_rev, :_id, :_attachments], :except => [:id]), default_headers))
      else
        result = JSON.parse(RestClient.put(uri, self.to_json(:methods => [:model_name, :_rev, :_id], :except => [:id]), default_headers))
      end
      @_rev = result['rev']
      result
    end

    def put_attachments
      (@attachments || {}).each { |name, attachment| put_attachment(name) if attachment[:dirty] }
    end
    
    def attachment_ivar(name)
      instance_variable_get("@#{ name }")
    end

    def attachment_content_type(name)
      instance_variable_get("@_#{ name }_content_type")
    end
    
  end

  class RecordNotFound < Exception
  end

  class DatabaseNotSet < Exception
  end
  
  class RecordInvalid < Exception
  end
  
end
