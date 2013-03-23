require 'foxglove'
require 'thor'

require 'foxglove/adapters'

module Foxglove
  class CLI < Thor
    desc 'init', 'initialize foxglove dir'
    def init(dir_name)
      if Dir.exists?(dir_name)
        say dir_name+' is aleady exist', :red
        return
      end

      FileUtils.mkdir_p(dir_name)
      say 'create: '+dir_name, :green

      initialize_dir = %w{sources sources/stylesheets sources/javascripts templates lib lib/adapters config public}
      initialize_dir.each do |dir|
        create_dir_name = dir_name+'/'+dir

        FileUtils.mkdir_p(create_dir_name)
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
      template_file_path = dir_name+'/templates/common.haml'
      f = open(template_file_path, 'w')
      f.print template_file
      f.close
      say 'create: '+template_file_path, :green

      say ''
      say 'create foxglove template: '+dir_name, :green
    end

    desc 'release', 'release sources'
    def release
      asset_adapter = Foxglove::Adapters.new()
      compile_items = search(Foxglove.config[:source_dir])

      compile_items.each do |item|
        unless asset_adapter.compilable?(item)
          out = open(item, 'rb').read
          out_path = Foxglove.config[:output_dir]+item.gsub(/^#{Foxglove.config[:source_dir]}/, '')
        else
          out = asset_adapter.compile(item)
          in_ext = File.extname(item).gsub(/^\./, '').to_sym
          out_ext = asset_adapter.adapters[in_ext].output_ext
          out_path = Foxglove.config[:output_dir]+item.gsub(/^#{Foxglove.config[:source_dir]}/, '').gsub(/#{in_ext.to_s}$/, out_ext.to_s)
        end

        out_dir = out_path.split('/')[0..-2].join('/')
        FileUtils.mkdir_p(out_dir)
        open(out_path, 'w').print(out)

        message = "create: #{item} -> #{out_path}"
        say message, :green
      end
    end

    private
    def search(original_path, items=[])
      exclude_items = (%w{. ..} + Foxglove.config[:exclude_ext]).join('|')
      exclude_items = Regexp.new("^(#{exclude_items})$")

      [original_path] if File.file?(original_path)

      Dir::entries(original_path).delete_if do |item|
        item.match(exclude_items)
      end.each do |item|
        item = [original_path, item].join('/')

        if File.file?(item)
          items << item
        else
          search(item, items)
        end
      end

      items
    end
  end
end
