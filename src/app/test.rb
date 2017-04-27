#!/usr/bin/env ruby
require 'date'

now = Time.now

create = Time.new(now.year, now.month, now.day)
p create.strftime('%Y-%m-%d %H:%M:%S')

yes = now - 24*60*60

now_time = now.strftime('%Y-%m-%d %H:%M:%S')
p now_time
yes_time = yes.strftime('%Y-%m-%d %H:%M:%S')
p yes_time


# p DateTime.strptime('2015-11-12 CET', '%Y-%m-%d %Z').to_time.to_s


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
