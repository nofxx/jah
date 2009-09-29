module Jah

  class Who < Collector
    EXEC =  "who"

    def self.all
      @who = `#{EXEC}`.to_a.map do |l|
        l = l.split(" ")

        hash = {}

        hash[:who] = l[0]
        hash[:terminal] = l[1]
        2.times{ l.delete(l[0]) }
        hash[:date] = l.join(" ")
        hash
      end
    end
  end
end
