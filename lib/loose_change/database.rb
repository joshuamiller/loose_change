require 'cgi'

module LooseChange
  class Database
    include Helpers
    extend Helpers
    
    attr_reader :server, :host, :name, :root

    def initialize(server, name)
      @name = name
      @server = server
      @host = server.uri
      @uri  = "/#{name.gsub('/','%2F')}"
      @root = host + uri
      create_database_unless_exists
    end
    
    def uri
      server.uri + @uri
    end
    
    def self.delete(server, name)
      begin
        RestClient.delete("#{ server }/#{ name }")
      rescue RestClient::ResourceNotFound
      end
    end
        
    def self.setup_design(database, model_name)
      RestClient.put("#{ database.uri }/_design/#{ CGI.escape(model_name) }",
                      { '_id' => "_design/#{ CGI.escape(model_name) }",
                        'language' => 'javascript',
                        'views' => { 'all' => { 'map' => "function(doc) {
                                                            if (doc['model_name'] == '#{ model_name }') {
                                                                emit(null, doc);
                                                            }
                                                          }" } } }.to_json, default_headers)
    end
    
    private
    
    def create_database_unless_exists
      unless JSON.parse(RestClient.get("#{server.uri}/_all_dbs", default_headers)).include?(name)
        RestClient.put uri, "", default_headers
      end
    end
    
  end
end
