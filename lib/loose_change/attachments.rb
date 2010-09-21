module LooseChange
  
  module Attachments
  end

  module AttachmentClassMethods
    
    def attach(name, file, args = {})
      attachment = args.merge :file => file, :dirty => true
      @attachments = (@attachments || {}).merge(name => attachment)
    end

    def attachment(name)
      return attachments[name][:file] if @attachments.try(:[], :name)
      begin
        result = retrieve_attachment(name)
        @attachments = (@attachments || {}).merge(name => {:file => result[:file], :dirty => false, :content_type => result[:content_type]})
        result[:file]
      rescue RestClient::ResourceNotFound
        nil
      end
    end
    
    def retrieve_attachment(name)
      { :file => RestClient.get("#{ uri }/#{ name }"),
        :content_type => JSON.parse(RestClient.get(uri))['_attachments']['name'] }
    end

    def put_attachment(name)
      return unless attachments[name]
      result = JSON.parse(RestClient.put("#{ uri }/#{ name }#{ '?rev=' + @_rev if @_rev  }", attachments[name][:file], {:content_type => attachments[name][:content_type], :accept => 'text/json'}))
      @_rev = result['rev']
    end
    
  end
  
end
