require 'yaml'
require 'active_support'
require 'active_support/core_ext'

require "foxglove/version"
require "foxglove/cli"

module Foxglove
  def self.config
    return @config unless @config.nil?
    default = {
      sitename: '',
      template_dir: './templates',
      default_template: 'common.haml',
      output_dir: './public',
      source_dir: './sources'
    }
    config = YAML.load_file('./config/foxglove.yml').symbolize_keys()

    @config = default.merge(default)
  end
end
