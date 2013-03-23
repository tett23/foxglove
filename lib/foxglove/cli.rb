require 'foxglove'
require 'thor'
require 'yaml'
require 'active_support'
require 'active_support/core_ext'

require 'foxglove/render'
require 'foxglove/adapters'

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

      asset_adapter = Foxglove::Adapters.new()
      compile_items = search(config[:assets_dir])
      compile_items.each do |item|
        in_ext = File.extname(item).gsub(/^\./, '').to_sym
        unless asset_adapter.adapters.key?(in_ext)
          message = "#{in_ext}に対応するAdapterが存在しません: #{item}"
          say message, :red
          next
        end

        compiled = asset_adapter.compile(item)

        out_ext = asset_adapter.adapters[in_ext].output_ext
        out_path = config[:output_dir]+item.gsub(/^#{config[:assets_dir]}/, '').gsub(in_ext.to_s, out_ext.to_s)

        out_dir = out_path.split('/')[0..-2].join('/')
        FileUtils.mkdir_p(out_dir)
        open(out_path, 'w').print(compiled)

        message = "compile: #{item} -> #{out_path}"
        say message, :green
      end
    end

    private
    def search(original_path, items=[])
      exclude_items = /^(\.|\.\.)$/

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

    def merge_options(options={})
      options = options.symbolize_keys()
      default = {
        sitename: '',
        template_dir: './sources/pages/templates',
        default_template: 'common.haml',
        pages_dir: './sources/pages',
        output_dir: './public',
        assets_dir: './sources/assets'
      }

      default.merge(options)
    end
  end
end
