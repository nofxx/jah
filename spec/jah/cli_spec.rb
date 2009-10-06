require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Jah::Cli do

  before do
    Cli.stub!(:puts)
    File.stub!(:exists?).and_return(false)
    Jah::Cli.stub!(:parse_options).and_return({})
    Jah::Cli.stub!(:autload_config)
  end

  it "should start with install/config" do
    Jah.should_receive(:mode).and_return(nil)
    Jah::Install.should_receive(:new)
    Jah::Cli.dispatch([])
  end

  it "should dispatch install" do
    Jah::Install.should_receive(:new)
    Jah::Cli.dispatch(["install"])
  end

  it "should start if mode" do
    Jah.should_receive(:mode).and_return(:xmpp)
    Jah::Agent.should_receive(:start).and_return(true)
    Jah::Cli.dispatch([])
  end

  it "should not write if it wasnt" do
    EM.should_receive(:stop)
    File.should_not_receive(:open)
    Jah::Cli.stop!
  end

  it "should write config down if changed" do
    Jah::Opt[:mode] = "xre"
    EM.should_receive(:stop)
    File.should_receive(:open).with(Opt[:config], "w+").and_yield(@mf = mock(File))
    @mf.should_receive(:write).exactly(2).times
    Jah::Cli.stop!
  end


end
