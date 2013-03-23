require 'active_support'
require 'active_support/core_ext'
require 'haml'
require 'RedCloth'

module Foxglove
  class Render
    EXCLUDE_ITEMS = /^(\.|\.\.|templates)$/

    def initialize(template_path)
      @template_path = template_path
      template = open(@template_path).read
      @engine = Haml::Engine.new(template)
    end

    def render(original_path, out_path, options={})
      default = {
        ext: '.html'
      }
      options = default.merge(options)

      if File.file?(original_path)
        _render(original_path, out_path, options[:ext])
        return
      end

      remove_exclude_items(Dir::entries(original_path)).each do |item|
        path = [original_path, item].join('/')
        out = [out_path, item].join('/')

        if File.file?(path)
          _render(path, out, options[:ext])
        else
          Dir.mkdir(out) unless File.exists?(out)

          remove_exclude_items(Dir::entries(path)).each do |item|
            render(path, out)
          end
        end
      end
    end

    private
    def _render(in_path, out_path, ext='.html')
      page = open(in_path).read

      rendered = @engine.render(Object.new) do |_|
        RedCloth.new(in_path).to_html
      end

      out_ext = File.extname(out_path)
      out_path = out_path.gsub(/#{out_ext}$/, ext)
      #say "create: #{original_path} -> #{out}", :green
      f = open(out_path, 'w')
      f.print(rendered)
      f.close
    end

    def remove_exclude_items(items)
      items.delete_if do |item|
        item.match(EXCLUDE_ITEMS)
      end
    end
  end
end
