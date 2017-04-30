module R2S
  class Date
    def self.now
      Time.now
    end

    def self.yesterday(date=Time.now)
      date - (24 * 60 * 60)
    end

    def self.format(date)
      date.strftime('%Y-%m-%d %H:%M:%S')
    end
  end
end
