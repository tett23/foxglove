require 'haml'

module Foxglove
  class HamlAdapter
    def compile(path)
      Haml::Engine.new(open(path).read).to_html
    end

    def compilable_ext
      [:haml]
    end

    def output_ext
      :html
    end
  end
end
