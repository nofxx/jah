require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Pkg do

  it "should instantiate" do
    Pkg.new(:installed, "ruby", "1.9.1").should be_valid
  end

  describe "One pkg" do
    before do
      @pkg = Pkg.new(:installed, "jah", "1.0.0", "Talk to your machines.")
    end

    it "should have a name" do
      @pkg.name.should eql("jah")
    end

    it "should have a version" do
      @pkg.version.should eql("1.0.0")
    end

    it "should have a description" do
      @pkg.desc.should eql("Talk to your machines.")
    end

    it "should have a installed meth" do
      @pkg.should be_installed
    end

    it "should check equality with others" do
      pkg2 = Pkg.new(:installed, "foo", "2.5b")
      @pkg.should_not == pkg2
    end

    it "should check equality with others 2" do
      pkg2 = Pkg.new(:installed, "jah", "1.0.0")
      @pkg.should == pkg2
    end

    it "should compare version" do
      pkg2 = Pkg.new(:installed, "jah", "1.0.1")
      @pkg.should be < pkg2
      pkg2.should be > @pkg
    end

    it "should not compare diff pkgs" do
      pkg2 = Pkg.new(:installed, "foo", "1.0.1")
      lambda { pkg2 > @pkg }.should raise_error
    end
  end
end
