require 'active_support'
require 'active_model'

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
end
