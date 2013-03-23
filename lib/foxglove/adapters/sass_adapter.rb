require 'sass'

require 'foxglove/adapters/adapter_interface'

module Foxglove
  class SassAdapter
    def initialize
    end

    def compile(path)
      Sass.compile_file(path)
    end

    def compilable_ext
      [:sass]
    end

    def output_ext
      :css
    end
  end
end
