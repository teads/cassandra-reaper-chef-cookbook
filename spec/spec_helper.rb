require 'chefspec'
require 'chefspec/berkshelf'

ChefSpec::Coverage.start!

RSpec.configure do |config|
  config.file_cache_path = '/tmp'
  config.platform = 'debian'
  config.version = '9.4'
end
