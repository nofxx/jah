module Jah

  class Disk < Collector
    attr_reader :path, :percent, :total, :free, :used, :mount

    def self.all
      @disks = `df`.to_a.reject { |dl| dl =~ /Size|Use|none/ }.map do |l|
        new l.split(" ")
      end
    end

    def initialize(args)
      @path, @total, @used, @free, @percent, @mount = args
      @total, @used, @free = [@total, @used, @free].map(&:to_i)
      @percent = @percent[0..-2].to_i
    end

    def self.mount
    end

    def self.umount
    end


  end

end
