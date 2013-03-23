require 'foxglove/init'

module Foxglove
  class << self
    def application
      @application ||= Foxglove::Init.new
    end
  end
end
