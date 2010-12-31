require 'rails'

module LooseChange
  class Railtie < Rails::Railtie
    rake_tasks do
      require File.dirname(__FILE__) + '/../tasks/loose_change'
    end
  end
end
