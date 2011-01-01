require 'active_support'
require 'active_support/core_ext'
require 'active_model'
require 'rest-client'
require 'json'
require 'will_paginate'
require 'will_paginate/collection'

module LooseChange
  extend ActiveSupport::Autoload

  autoload :Attributes, File.dirname(__FILE__) + '/loose_change/attributes'
  autoload :Attachments, File.dirname(__FILE__) + '/loose_change/attachments'
  autoload :Errors, File.dirname(__FILE__) + '/loose_change/errors'
  autoload :Naming, File.dirname(__FILE__) + '/loose_change/naming'
  autoload :Base, File.dirname(__FILE__) + '/loose_change/base'
  autoload :Persistence, File.dirname(__FILE__) + '/loose_change/persistence'
  autoload :Database, File.dirname(__FILE__) + '/loose_change/database'
  autoload :Server, File.dirname(__FILE__) + '/loose_change/server'
  autoload :Views, File.dirname(__FILE__) + '/loose_change/views'
  autoload :Pagination, File.dirname(__FILE__) + '/loose_change/pagination'
  autoload :Helpers, File.dirname(__FILE__) + '/loose_change/helpers'
  autoload :Spatial, File.dirname(__FILE__) + '/loose_change/spatial'
  autoload :Validations, File.dirname(__FILE__) + '/loose_change/validations'
end


require (File.dirname(__FILE__) + '/loose_change/railtie') if defined?(Rails::Railtie)
