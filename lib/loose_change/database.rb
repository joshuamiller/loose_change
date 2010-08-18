module LooseChange
  class Database
    attr_reader :server, :host, :name, :root

    def initialize(server, name)
      @name = name
      @server = server
      @host = server.uri
      @uri  = "/#{name.gsub('/','%2F')}"
      @root = host + uri
    end
    
    def uri
      server.uri + @uri
    end
  end
end
