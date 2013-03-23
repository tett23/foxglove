require 'foxglove'
require 'thor'

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

      initialize_dir = %w{sources sources/assets sources/pages sources/pages/templates sources/adapter config public}
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
  end
end
