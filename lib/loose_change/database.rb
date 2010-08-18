module LooseChange
  class Database
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
    
    private
    
    def create_database_unless_exists
      unless JSON.parse(RestClient.get("#{server.uri}/_all_dbs", default_headers)).include?(name)
        RestClient.put uri, "", default_headers
      end
    end
    
    def default_headers
      {
        :content_type => :json,
        :accept       => :json
      }
    end

  end
end
