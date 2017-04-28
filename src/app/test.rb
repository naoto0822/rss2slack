#!/usr/bin/env ruby
require 'date'
require_relative './date'

n = R2S::Date::now
p R2S::Date::format(n)
y = R2S::Date::yesterday(n)
p R2S::Date::format(y)

p "-------"

y2 = R2S::Date::yesterday
p R2S::Date::format(y2)

p "--------"

now = Time.now
yes = now - 24*60*60

now_time = now.strftime('%Y-%m-%d %H:%M:%S')
p now_time

yes_time = yes.strftime('%Y-%m-%d %H:%M:%S')
p yes_time

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
