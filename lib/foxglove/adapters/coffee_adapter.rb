require 'coffee-script'

module Foxglove
  class CoffeeAdapter
    def compile(path)
      CoffeeScript.compile(File.read(path))
    end

    def compilable_ext
      [:coffee]
    end

    def output_ext
      :js
    end
  end
end
