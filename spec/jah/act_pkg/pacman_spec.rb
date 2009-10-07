require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require "jah/act_pkg/pacman"

describe Pacman do

  before do
    @pac ||= Pacman.new
  end

  describe "Searching" do
    before do
      @pac.stub!(:"`").and_return(SS)
      @pkgs = @pac.search("ruby")
    end

    it "should find pkgs" do
      @pac.should_receive(:"`").with("pacman -Ss ruby").and_return(SS)
      first = @pac.search("ruby")[0]
      first.name.should eql("ruby")
      first.desc.should eql("An object-oriented language for quick and easy programming")
    end

    it "should work nicely" do
      @pkgs[1].name.should eql("ruby-docs")
      @pkgs[1].desc.should eql("Documentation files for ruby")
    end

    it "should not be installed" do
      @pkgs[1].should_not be_installed
    end

    it "should install if I want" do
      Pacman.should_receive(:new).and_return(@pac)
      @pac.should_receive(:"`").with("pacman -Sy --noconfirm ruby")
      @pkgs[0].install
    end

  end

  it "should install stuff" do
    @pac.should_receive(:"`").with("pacman -Sy --noconfirm foo")
    @pac.install mock(Pkg, :name => "foo")
  end

  it "should list pkgs" do
    @pac.should_receive(:"`").with("pacman -Q ").and_return(QL)
    @pac.all.first.should be_instance_of(Pkg)
  end


  describe "List" do

    before do
      @pac.stub!(:"`").and_return(QL)
      @pkgs = @pac.all
      @ruby = @pkgs[11]
    end

    it "should have name" do
      @pkgs[0].name.should eql("a2ps")
    end

    it "should have version" do
      @pkgs[0].version.should eql("4.14-1")
    end

    it "should fetch info about a pkg" do
      @ruby.info.should be_instance_of Hash #("http://www.ruby-lang.org/en/")
    end

    it "should fetch url" do
      @ruby.url.should eql("http://www.ruby-lang.org/en/")
    end

    it "should fetch arch" do
      @ruby.arch.should eql("i686")
    end

    it "should fetch desc" do
      @ruby.desc.should eql("An object-oriented language for quick and easy programming")
    end

    it "should fetch license" do
      @ruby.license.should eql("custom")
    end

  end

SS = <<SS
extra/ruby 1.9.1_p243-2 [4.67 MB]
    An object-oriented language for quick and easy programming
extra/ruby-docs 1.9.1_p243-2 [0.87 MB]
    Documentation files for ruby
SS

QL = <<QL
a2ps 4.14-1
a52dec 0.7.4-4
acl 2.2.47-2
alsa-lib 1.0.21.a-1
ca-certificates 20090709-1
couchdb-svn 784601-1
emacs-cvs 20090730-1
emacs-magit-git 20090811-1
flashplugin 10.0.32.18-1.1
hal-info 0.20090716-2
libmad 0.15.1b-4
ruby 1.8.7_p174-1
xz-utils 4.999.9beta-1
QL

QI = <<QI
Name           : ruby
Version        : 1.8.7_p174-1
URL            : http://www.ruby-lang.org/en/
Licenses       : custom
Groups         : None
Provides       : None
Depends On     : gdbm>=1.8.3  db>=4.7.25  openssl>=0.9.8k  zlib>=1.2.3.3 readline>=6
Optional Deps  : None
Required By    : rubygems  shoes
Conflicts With : None
Replaces       : None
Installed Size : 11308.00 K
Packager       : Allan McRae <allan@archlinux.org>
Architecture   : i686
Build Date     : Mon 20 Jul 2009 12:29:57 AM BRT
Install Date   : Thu 23 Jul 2009 10:47:30 PM BRT
Install Reason : Explicitly installed
Install Script : No
Description    : An object-oriented language for quick and easy programming


QI


end
