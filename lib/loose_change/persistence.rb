module LooseChange
  module Persistence

    attr_accessor :new_record, :destroyed, :database, :id
    
    def new_record?()   @new_record end
    def destroyed?()    @destroyed  end
    
    def persisted?
      !(new_record? || destroyed?)
    end
    
    def save
      raise "Cannot save without database set." unless @database
      new_record? ? post_record : put_record
    end

    def post_record
      result = JSON.parse(RestClient.post(database.uri, self.to_json(:methods => [:model_name]), default_headers))
      @id = result['id']
      @new_record = false
      result
    end

    def put_record
    end
    
    private

    def default_headers
      {
        :content_type => :json,
        :accept       => :json
      }
    end
    
  end
end
