require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Jah::Cli do

  before do
    Cli.stub!(:puts)
    Opt.stub!(:puts)
    File.stub!(:exists?).and_return(false)
    Jah::Cli.stub!(:parse_options).and_return({})
    Opt.stub!(:autoload_config)
  end

  it "should start with install/config" do
    Opt.should_receive(:mode).and_return(nil)
    Jah::Install.should_receive(:new)
    Jah::Cli.work([])
  end

  it "should work install" do
    Jah::Install.should_receive(:new)
    Jah::Cli.work(["install"])
  end

  it "should start if mode" do
    Opt.should_receive(:mode).and_return(:xmpp)
    Jah::Agent.should_receive(:start).and_return(true)
    Jah::Cli.work([])
  end

  describe "Config files" do

  it "should not write down if it wasnt changed" do
    pending
    EM.should_receive(:stop)
    File.should_not_receive(:open)
    Jah::Cli.stop!
  end

  it "should write config down if changed" do
    Opt.mode = "xre"
    EM.should_receive(:stop)
    File.should_receive(:open).with(Opt[:config], "w+").and_yield(@mf = mock(File))
    @mf.should_receive(:write).exactly(2).times
    Jah::Cli.stop!
  end
end


end
