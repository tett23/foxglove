require 'foxglove/adapters/adapter_interface'
require 'foxglove/adapters/sass_adapter'
require 'foxglove/adapters/coffee_adapter'
require 'foxglove/adapters/textile_adapter'

module Foxglove
  class Adapters
    def initialize
      load_adapters()
    end
    attr_reader :adapters

    def compile(path)
      adapter_name = File.extname(path).gsub(/^\./, '').to_sym

      return false unless @adapters.key?(adapter_name)

      adapter = @adapters[adapter_name]
      adapter.compile(path)
    end

    def compilable?(path)
      ext = File.extname(path).gsub(/^\./, '').to_sym

      adapters.key?(ext)
    end

    private
    def load_adapters
      @adapters = {}

      Dir[Foxglove.config[:lib_dir]+"/adapters/*.rb"].each {|file| require file }

      foxglove_constants = Foxglove.constants - Object.constants
      adapters = foxglove_constants.delete_if do |item|
        !item.match(/Adapter$/)
      end
      adapters.map do |adapter_name|
        adapter_name = 'Foxglove::'+adapter_name.to_s
        adapter_class = adapter_name.classify.constantize

        adapter = adapter_class.dup.__send__(:include, AdapterInterface).new
        adapter.compilable_ext.each do |ext|
          @adapters[ext] = adapter
        end
      end
    end
  end
end
