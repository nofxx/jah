require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')


describe ActPkg do

  it "should detect archlinux" do
    File.stub!(:read).and_return(" Arch Linux \r  (\n) (\l)")
    ActPkg.detect.should eql(:pacman)
  end

  it "should detect debian like" do
    File.stub!(:read).and_return(" Ubuntu karmic (development branch) \n \l")
    ActPkg.detect.should eql(:apt)
  end

  it "should detect slack" do
    File.stub!(:read).and_return(" Welcome to \s \r (\l)")
    ActPkg.detect.should eql(:slackpkg)
  end

  it "should detect gentoo" do
    File.stub!(:read).and_return(" This is \n.\O (\s \m \r) \t")
    ActPkg.detect.should eql(:portage) # sparta
  end

  it "should detect centos" do
    File.stub!(:read).and_return("  CentOS release 5.2 (Final)\n Kernel \r on an \m")
    ActPkg.detect.should eql(:yum)
  end

  it "should return an instance of the correct adapter (arch)" do
    ActPkg.stub!(:detect).and_return(:pacman)
    ActPkg.get_mine.should be_instance_of Pacman
  end
end

