module LooseChange
  class Server
    
    attr_accessor :uri

    def initialize(server = "http://127.0.0.1:5984")
      @uri = server
    end

  end
end
