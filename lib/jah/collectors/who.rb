module Jah

  class Who < Collector

    def self.all
      @who = `who`.to_a.map do |l|
        l = l.split(" ")

        hash = {}

        hash[:who] = l[0]
        hash[:tty] = l[1]
        2.times{ l.delete(l[0]) }
        hash[:date] = l.join(" ")
        hash
      end
    end
  end
end
