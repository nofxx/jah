module Jah

  class Disk < Collector
    EXEC =  "df -h"

    def self.all
      @disks = `#{EXEC}`.to_a.reject { |dl| dl =~ /Size|none/ }.map do |l|
        l = l.split(" ")
        { :path => l[0], :total => l[1], :used => l[2], :avail => l[3], :percent => l[4]}
      end
    end

  end
end
