#!/usr/bin/env ruby

p File.expand_path(File.dirname(__FILE__) + '/../')
# p File.expand_path '../exec/worker.rb', __FILE__

module R2S
  class Test
    attr_accessor :name
    def initialize(name)
      @name = name
    end
  end
end
