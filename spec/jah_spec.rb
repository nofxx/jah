require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Jah" do

  it "should register commands" do
    Jah::REG.should be_instance_of Array
  end
end
