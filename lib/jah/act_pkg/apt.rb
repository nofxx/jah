
module Jah
  class Apt < ActPkg::Base
    BIN = "aptitude"


    def self.all
      "dpkg -l"
    end


  end
end
