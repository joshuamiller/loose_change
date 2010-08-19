require 'active_support'
require 'active_support/core_ext'
require 'active_model'
require 'rest-client'
require 'json'

module LooseChange
  extend ActiveSupport::Autoload

  autoload :Attributes, File.dirname(__FILE__) + '/loose_change/attributes'
  autoload :Callbacks, File.dirname(__FILE__) + '/loose_change/callbacks'
  autoload :Dirty, File.dirname(__FILE__) + '/loose_change/dirty'
  autoload :Errors, File.dirname(__FILE__) + '/loose_change/errors'
  autoload :Naming, File.dirname(__FILE__) + '/loose_change/naming'
  autoload :Observer, File.dirname(__FILE__) + '/loose_change/observer'
  autoload :I18n, File.dirname(__FILE__) + '/loose_change/i18n'
  autoload :Validations, File.dirname(__FILE__) + '/loose_change/validations'
  autoload :Base, File.dirname(__FILE__) + '/loose_change/base'
  autoload :Persistence, File.dirname(__FILE__) + '/loose_change/persistence'
  autoload :Database, File.dirname(__FILE__) + '/loose_change/database'
  autoload :Server, File.dirname(__FILE__) + '/loose_change/server'
  autoload :Views, File.dirname(__FILE__) + '/loose_change/views'
  autoload :Helpers, File.dirname(__FILE__) + '/loose_change/helpers'
end
