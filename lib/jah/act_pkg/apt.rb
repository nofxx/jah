
module Jah
  class Apt
    BIN = "aptitude"


  def self.all
    "dpkg -l"
  end


  end
end
