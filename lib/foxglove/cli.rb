require 'foxglove'
require 'thor'
require 'yaml'
require 'active_support'
require 'active_support/core_ext'

require 'foxglove/render'

module Foxglove
  class CLI < Thor
    desc 'init', 'initialize foxglove dir'
    def init(dir_name)
      if Dir.exists?(dir_name)
        say dir_name+' is aleady exist', :red
        return
      end

      Dir.mkdir(dir_name)
      say 'create: '+dir_name, :green

      initialize_dir = %w{sources sources/assets sources/assets/stylesheets sources/assets/javascripts sources/pages sources/pages/templates lib lib/adapters config public}
      initialize_dir.each do |dir|
        create_dir_name = dir_name+'/'+dir

        Dir.mkdir(create_dir_name)
        say 'create: '+create_dir_name, :green
      end

      config_file = <<YAML
sitename: example
YAML
      config_file_path = dir_name+'/config/foxglove.yml'
      f = open(config_file_path, 'w')
      f.print config_file
      f.close
      say 'create: '+config_file_path, :green

      template_file = <<HAML
!!! 5
%html
  %head
    %meta{charset: 'utf-8'}
  %body
    =yield
HAML
      template_file_path = dir_name+'/sources/pages/templates/common.haml'
      f = open(template_file_path, 'w')
      f.print template_file
      f.close
      say 'create: '+template_file_path, :green

      say ''
      say 'create foxglove template: '+dir_name, :green
    end

    desc 'release', 'compile pages'
    def release(in_path=nil, out_path=nil)
      config = YAML.load_file('./config/foxglove.yml').symbolize_keys()
      config = merge_options(config)

      in_path ||= config[:pages_dir]
      out_path ||= config[:output_dir]

      template_path = [config[:template_dir], config[:default_template]].join('/')
      engine = Foxglove::Render.new(template_path)
      engine.render(in_path, out_path)
    end

    private
    def merge_options(options={})
      options = options.symbolize_keys()
      default = {
        sitename: '',
        template_dir: './sources/pages/templates',
        default_template: 'common.haml',
        pages_dir: './sources/pages',
        output_dir: './public'
      }

      default.merge(options)
    end
  end
end
