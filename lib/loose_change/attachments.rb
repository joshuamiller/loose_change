module LooseChange
  
  module Attachments
  end

  module AttachmentClassMethods
    
    # Attach a file to this model, to be stored inline in
    # CouchDB.  Note that the file will not actually be transferred
    # to CouchDB until #save is called. The +name+ parameter will be
    # used on CouchDB and in Loose Change to retrieve the attachment
    # later. If you set the <tt>:content_type</tt> key in the optional +args+
    # hash, that content-type will be set on the attachment in CouchDB
    # and available when the model is retrieved.
    #
    #   recipe = Recipe.create!(:name => "Lasagne")
    #   recipe.attach(:photo, File.open("lasagne.png"), :content_type
    #   => 'image/png'
    #   recipe.save
    def attach(name, file, args = {})
      attachment = args.merge :file => file, :dirty => true
      @attachments = (@attachments || {}).merge(name => attachment)
    end
    
    # Returns the file identified by +name+ on a Loose Change model
    # instance, whether or not that file has been saved back to
    # CouchDB.  Will return nil if no attachment by that name exists.
    def attachment(name)
      return attachments[name][:file] if @attachments.try(:[], :name).try(:[], :file)
      begin
        result = retrieve_attachment(name)
        @attachments = (@attachments || {}).merge(name => {:file => result[:file], :dirty => false, :content_type => result[:content_type]})
        result[:file]
      rescue RestClient::ResourceNotFound
        nil
      end
    end

    # Returns a hash composed of <tt>file</tt> and <tt>content_type</tt> as
    # returned from CouchDB identified by +name+.
    def retrieve_attachment(name)
      { :file => RestClient.get("#{ uri }/#{ name }"),
        :content_type => JSON.parse(RestClient.get(uri))['_attachments']['name'] }
    end
    
    # Explicitly transfers an attachment to CouchDB without saving the
    # rest of the model.
    #
    #   recipe.attach(:photo, File.open("lasagne.png"), :content_type
    #   => 'image/png'
    #   recipe.put_attachment(:photo)
    def put_attachment(name)
      return unless attachments[name]
      result = JSON.parse(RestClient.put("#{ uri }/#{ name }#{ '?rev=' + @_rev if @_rev  }", attachments[name][:file], {:content_type => attachments[name][:content_type], :accept => 'text/json'}))
      @_rev = result['rev']
    end
       
  end
  
end
