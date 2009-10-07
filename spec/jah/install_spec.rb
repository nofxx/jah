require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Install do

  it "should write to the correct path" do
    pending
    i = Install.new
    i.stub!(:gets).and_return("")
    File.should_receive(:open).with("jah")
    i.write_down

  end

end

