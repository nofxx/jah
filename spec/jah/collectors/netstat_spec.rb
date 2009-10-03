require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')


describe Netstat do

  it "should count connections" do
    Netstat.should_receive(:"`").with("netstat -n | grep -i established | wc -l").and_return("9")
    Netstat.count.should eql(9)
  end

  

end
