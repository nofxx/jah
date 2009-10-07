require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Opt do

  it "should behave as an hash" do
    Opt[:foo] = 5
    Opt[:foo].should eql(5)
  end

  it "should be lil more smart" do
    Opt.numero = 5
    Opt.numero.should eql(5)
  end

  it "should work with booleans" do
    Opt.evil = true
    Opt.evil.should be_true
  end

  it "should even provide a ?" do
    Opt.evil = true
    Opt.should be_evil
  end

  it "should get hostname" do
    Opt.should_receive(:"`").with("hostname").and_return("msweet")
    Opt.hostname.should eql("msweet")
  end


  it "should get locale" do
    Opt.should_receive(:"`").with("locale | grep LANG").and_return("LANG=en_US.utf8")
    Opt.locale.should eql("en_us")
  end


end
