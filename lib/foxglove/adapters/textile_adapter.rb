require 'haml'
require 'RedCloth'

module Foxglove
  class TextileAdapter
    def compile(page)
      engine.render(Object.new) do |_|
        RedCloth.new(open(page).read).to_html
      end
    end

    def compilable_ext
      [:textile]
    end

    def output_ext
      :html
    end

    private
    def engine
      return @engine unless @engine.nil?

      template_path = [Foxglove.config[:template_dir], Foxglove.config[:default_template]].join('/')
      template = open(template_path).read
      @engine = Haml::Engine.new(template)
    end
  end
end
