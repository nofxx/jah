require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Jah::Cli do

  before do
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

end
