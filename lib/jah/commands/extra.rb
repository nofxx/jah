module Jah
  class Extra
    include Command
    register :change_lang, 'change\slang.*\s(\w*)$'

    # change\slang.*\s(\w*)$
    def self.change_lang(_, new)
      I18n.default_locale = new

    end


  end
end
