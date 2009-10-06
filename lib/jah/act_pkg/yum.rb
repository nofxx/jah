module Jah

  class Yum

    def install(what)
      "yum install #{what}"
    end

    def uninstall
      "remove"
    end

    def update
      "check-update"
    end
  end

end
