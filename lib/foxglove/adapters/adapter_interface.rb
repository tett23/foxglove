module Foxglove
  module AdapterInterface
    def compile(path)
      raise self.class.to_s+'#'+__method__.to_s+' が未定義です'
    end

    def compilable_ext
      raise self.class.to_s+'#'+__method__.to_s+' が未定義です'
    end

    def output_ext
      raise self.class.to_s+'#'+__method__.to_s+' が未定義です'
    end
  end
end
