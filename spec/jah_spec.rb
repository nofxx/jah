require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Jah" do

  it "should load the locales fine" do
    I18n.available_locales.should include :pt_br
  end

end
